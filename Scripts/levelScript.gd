extends Node2D

const maxNum = 14

@export var myNum = 0
@export var fader : AnimationPlayer

func _ready() -> void:
	MusicPlayer.playMusic("res://Sounds/Music/level_music.ogg")

func nextLevel():
	if (myNum >= maxNum): go_to_title()
	else:
		if (fader):
			fader.play("FadeOut")
			await fader.animation_finished
		get_tree().change_scene_to_file("res://Scenes/Levels/level_"+str(myNum+1)+".tscn")

func go_to_title():
	if (fader):
		if (fader.is_playing()): return
		fader.play("FadeOut")
		await fader.animation_finished
	MusicPlayer.fadeOutMusic()
	get_tree().change_scene_to_file("res://Scenes/Screens/TitleScreen.tscn")
