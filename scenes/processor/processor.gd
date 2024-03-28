extends Control

@export var filesLog : RichTextLabel
@export_file("*.tscn") var designerScene

@onready var archiveDir = Global.dataDir
@onready var tweetMediaDir = archiveDir + "/tweets_media"

var tweets
var filesToCopy = []
var userData

func logText(text):
	filesLog.text += "\n[center]" + text + "[/center]"

func recursiveDeleteDirectory(directory):
	var d = DirAccess.open(directory)
	
	for dir in d.get_directories():
		recursiveDeleteDirectory(directory+ "/" + dir)
	
	for file in d.get_files():
		d.remove(file)
	
	d.remove(directory)

func _ready():
	get_tree().create_timer(0.5)
	var dir = DirAccess.open("user://")
	
	if dir.dir_exists("archive"):
		await recursiveDeleteDirectory("user://archive")
		logText("[color=red]Deleted old archive[/color]")
	
	dir.make_dir("user://archive")
	dir.make_dir("user://archive/profile")
	dir.make_dir("user://archive/media")
	logText("[color=green]Created new archive[/color]\n/archive\n/archive/profile\n/archive/media")
	
	var profileDataFile = FileAccess.open(Global.dataDir + "/profile.js", FileAccess.READ)
	var profileData = profileDataFile.get_as_text()
	
	profileData = profileData.erase(0,profileData.find("["))

	profileData = JSON.parse_string(profileData)[0] # now we have the actual data as a dict

	var userDataFile = FileAccess.open(Global.dataDir + "/account.js", FileAccess.READ)
	userData = userDataFile.get_as_text()
	
	userData = userData.erase(0,userData.find("["))

	userData = JSON.parse_string(userData)[0]

	# get images dir
	var profileDir = archiveDir + "/profile_media"
	var profileDirFiles = DirAccess.get_files_at(profileDir)

	# get profile pics
	var profilePic : String = profileData.profile.avatarMediaUrl
	var banner : String
	
	profilePic = profilePic.right(len(profilePic) - profilePic.rfind("/") - 1)
	
	for file in profileDirFiles:
		if file.ends_with(profilePic):
			profilePic = file
		else:
			banner = file
	
	# copy profile pics
	DirAccess.copy_absolute(profileDir + "/" + profilePic, "user://archive/profile/profile.png")
	DirAccess.copy_absolute(profileDir + "/" + banner, "user://archive/profile/banner.png")
	logText("[color=gray]Copied[/color] " + profilePic + " [color=gray]to[/color] /archive/profile/profile.png")
	logText("[color=gray]Copied[/color] " + banner + " [color=gray]to[/color] /archive/profile/banner.png")
	
	# create index html
	var htmlDoc = FileAccess.open("res://template/index.html", FileAccess.READ)
	var indexPage = htmlDoc.get_as_text()
	htmlDoc.close()
	
	indexPage = indexPage.replace("!USER!", userData.account.accountDisplayName)
	indexPage = indexPage.replace("!BIO!", profileData.profile.description.bio)
	indexPage = indexPage.replace("!LINK!", profileData.profile.description.website)
	
	htmlDoc = FileAccess.open("user://archive/index.html", FileAccess.WRITE)
	htmlDoc.store_string(indexPage)
	htmlDoc.close()
	
	logText("[color=green]Created index.html[/color]")

	# copy tweets file data to be modified
	var tweetsFile = FileAccess.open(archiveDir + "/tweets.js", FileAccess.READ)
	tweets = tweetsFile.get_as_text()
	tweetsFile.close()
	
	tweets = tweets.erase(0, tweets.find("["))
	
	tweets = JSON.parse_string(tweets)

	filesToCopy = DirAccess.get_files_at(tweetMediaDir)

func _process(delta):
	# copy tweet media and modify tweets file
	if len(filesToCopy) > 0:
		var file = filesToCopy[0]
		var tweetID = file.left(file.find("-"))
		var filetype = file.right(len(file)-file.rfind("."))
		
		DirAccess.copy_absolute(tweetMediaDir + "/" + file, "user://archive/media/" + file)
		
		logText("[color=gray]Copied[/color] " + file + " [color=gray]to[/color] /archive/media/" + file)
		
		for tweet in tweets:
			tweet = tweet.tweet
			if tweet.id_str == tweetID:
				if !tweet.has("med"):
					tweet.med = [file]
				else:
					tweet.med.append(file)
				break
		
		filesToCopy.remove_at(0)
	else:
		# create js file
		var jsDoc = FileAccess.open("res://template/loadposts.js", FileAccess.READ)
		var js = jsDoc.get_as_text()
		jsDoc.close()
		
		tweets = JSON.stringify(tweets)
		
		js = js.replace("!USER!", userData.account.username)
		js = js.replace("!JSON!", tweets)
		
		jsDoc = FileAccess.open("user://archive/loadposts.js", FileAccess.WRITE)
		jsDoc.store_string(js)
		jsDoc.close()
		
		logText("[color=green]Created loadposts.js[/color]")
		
		set_process(false)
		$VBoxContainer/NextButton.disabled = false
		$VBoxContainer/Label.text = "Processed archive folder."


func _on_next_button_pressed():
	get_tree().change_scene_to_file(designerScene)
