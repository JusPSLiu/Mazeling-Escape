extends TextureRect

@export var numLevels = 16
@onready var fader : AnimationPlayer = $Fader
@onready var levelContainer : GridContainer = $LevelLayer/ChapterMenu/BoxContainer
@onready var buttonSound : AudioStreamPlayer = $ButtonSound

const levelButton = preload("res://Scenes/UI/LevelButton.tscn")

func _ready() -> void:
	for i in range(numLevels):
		var newbutton = levelButton.instantiate()
		newbutton.get_child(0).text = str(i+1)
		levelContainer.add_child(newbutton)
		newbutton.connect("pressed", play.bind(i))
	MusicPlayer.playMusic("res://Sounds/Music/title.ogg")

func play(level = -100):
	if (level < 0): level = GlobalVariables.currentLevel
	
	if (fader.is_playing()): return
	buttonSound.play()
	fader.play("FadeOut")
	MusicPlayer.fadeOutMusic()
	await fader.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/level_"+str(level)+".tscn")

func showLevels():
	buttonSound.play()
	$LevelLayer.show()
	
func hideLevels():
	buttonSound.play()
	$LevelLayer.hide()
