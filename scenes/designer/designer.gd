extends Control

@export var backgroundPickerBtn : ColorPickerButton
@onready var backgroundPicker : ColorPicker = backgroundPickerBtn.get_picker()
var backgroundPresets = ["52446a","af3b3b","446a4b","1d1e36"]

@export var pf : Node2D

@export_file("*.tscn") var indexScene

var pfpRounding = 0
var bannerRounding = 25
var mediaRounding = 0

func _ready():
	for colour in backgroundPresets:
		backgroundPicker.add_preset(Color(colour))

func _on_bg_colour_color_changed(color):
	RenderingServer.set_default_clear_color(color)

func _on_pfp_rounding_item_selected(index):
	pfpRounding = index
	
	match index:
		0:
			pf.showCircle()
		1:
			pf.showSquircle()
		2:
			pf.showSharp()

func _on_banner_rounding_item_selected(index):
	match index:
		0:
			pf.banCircle()
			bannerRounding = 25
		1:
			pf.banSquare()
			bannerRounding = 0

func _on_media_rounding_item_selected(index):
	match index:
		0:
			pf.circleMedia()
			mediaRounding = 25
		1:
			pf.squareMedia()
			mediaRounding = 0

func _on_folder_pressed():
	OS.shell_show_in_file_manager(OS.get_user_data_dir() + "/archive")

func _on_save_pressed():
	var f = FileAccess.open("res://template/style.css", FileAccess.READ)
	var css = f.get_as_text()
	f.close()
	
	css = css.replace("!BGCOL!", backgroundPicker.color.to_html(false))
	css = css.replace("!BANNER!", str(bannerRounding))
	css = css.replace("!MEDIA!", str(mediaRounding))
	
	match pfpRounding:
		0:
			css = css.replace("!PFP!", "100%")
		1:
			css = css.replace("!PFP!", "25px")
		2:
			css = css.replace("!PFP!", "0")
	
	f = FileAccess.open("user://archive/style.css", FileAccess.WRITE)
	f.store_string(css)
	f.close()


func _on_exit_pressed():
	get_tree().change_scene_to_file(indexScene)
