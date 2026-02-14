extends Area2D
@onready var water_sound = $AudioStreamPlayer2D

var target_volume = -10
var fade_speed = 3.0

func _ready():
	water_sound.play()

func _process(delta):
	water_sound.volume_db = move_toward(
	water_sound.volume_db,
	target_volume,
	fade_speed * 20.0 * delta
)


func _on_WaterZone_body_entered(body):
	if body.is_in_group("player"):
		target_volume = -8

func _on_WaterZone_body_exited(body):
	if body.name == "Player":
		target_volume = -40


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
