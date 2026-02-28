extends Area2D

@export var value := 1
@onready var sfx = $star_collect_sfx

func _ready() -> void:
	print("SFX node: ", sfx)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_star(value)
		print("⭐ Star collected")
		$AnimatedSprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		sfx.play()
		await sfx.finished
		queue_free()
