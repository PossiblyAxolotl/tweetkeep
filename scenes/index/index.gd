extends Control

@export var fileDialog : FileDialog
@export var errorText : RichTextLabel
@export var continueButton : Button

@export_file("*.tscn") var processorScene
@export_file("*.tscn") var cssScene

const errorMessages = [
	"[center][color=red]No data directory found.[/color][/center]",
	"[center][color=green]Data directory located![/color][/center]"
]

func _on_open_folder_button_pressed():
	fileDialog.popup()

func _on_file_dialog_dir_selected(dir):
	var d = DirAccess.open(dir)
	var hasData = d.dir_exists("data")
	
	continueButton.disabled = !hasData
	errorText.text = errorMessages[int(hasData)]

	if hasData:
		d.change_dir("data")
		var dataDir = d.get_current_dir()
		Global.dataDir = dataDir
		errorText.text += "\n[center][color=gray]" + dataDir + "[/color][/center]"

func _on_exit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	get_tree().change_scene_to_file(processorScene)


func _on_get_archive_2_pressed():
	get_tree().change_scene_to_file(cssScene)
