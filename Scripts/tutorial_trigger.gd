extends Area2D

@export var animationPlayer : AnimationPlayer

@export var animationName : String

var triggered = false

func _on_body_entered(body: Node2D) -> void:
	if(!triggered and body.is_in_group("Pin")):
		triggered = true
		animationPlayer.play(animationName)
