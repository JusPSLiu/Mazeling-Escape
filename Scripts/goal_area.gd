extends Area2D


@onready var level : Node2D = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Pin")):
		level.nextLevel()
