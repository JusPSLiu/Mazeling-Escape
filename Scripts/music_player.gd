extends AudioStreamPlayer

@onready var animator = $musicAnimator

var currentMusic : String = ""

func fadeOutMusic():
	animator.play("out")
	currentMusic = ""

func playMusic(music_str = null):
	animator.stop()
	volume_db = 0
	if (music_str):
		if (music_str == currentMusic): return
		currentMusic = music_str
		set_stream(load(music_str))
	play()
