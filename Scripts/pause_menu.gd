extends CanvasLayer

@onready var musicslider = $ColorRect/VBoxContainer/MusicSlider
@onready var soundslider = $ColorRect/VBoxContainer/SoundSlider
@onready var fader : AnimationPlayer = get_parent().get_node("Fader")
@onready var pauseMenu : ColorRect = $ColorRect
@onready var buttonSound : AudioStreamPlayer = $ButtonSound
@onready var levelLabel : Label = $ColorRect/CurrentLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musicslider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(1)))
	soundslider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(2)))
	levelLabel.text = "LEVEL "+str(get_parent().myNum+1)

func togglePauseFall():
	buttonSound.play()
	pauseMenu.visible = !pauseMenu.visible
	get_tree().paused = pauseMenu.visible


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_exit_pressed() -> void:
	if (fader):
		if (fader.is_playing()): return
		buttonSound.play()
		fader.play("FadeOut")
		await fader.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Screens/TitleScreen.tscn")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("pause")):
		togglePauseFall()
