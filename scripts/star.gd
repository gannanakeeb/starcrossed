extends Area2D

@export var value := 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_star(value)
		queue_free()
