extends TextureRect

@export var numLevels = 15
@onready var fader : AnimationPlayer = $Fader
@onready var levelContainer : GridContainer = $LevelLayer/ChapterMenu/BoxContainer

const levelButton = preload("res://Scenes/UI/LevelButton.tscn")

func _ready() -> void:
	for i in range(numLevels):
		var newbutton = levelButton.instantiate()
		newbutton.get_child(0).text = str(i+1)
		levelContainer.add_child(newbutton)
		newbutton.connect("pressed", play.bind(i))

func play(level = 0):
	if (fader.is_playing()): return
	fader.play("FadeOut")
	await fader.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/level_"+str(level)+".tscn")

func showLevels():
	$LevelLayer.show()
	
func hideLevels():
	$LevelLayer.hide()
