extends Area2D


@export var required_stars := 3
@export var riddle_ui: CanvasLayer

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if body.stars_collected >= required_stars:
		riddle_ui.show()
	else:
		print("You need more stars")
