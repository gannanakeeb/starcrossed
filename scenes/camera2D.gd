extends Camera2D

@export var target: Node2D = null
@export var follow_smoothing: float = 5.0

func _process(delta: float) -> void:
	if target != null:
		global_position = global_position.lerp(target.global_position, follow_smoothing * delta)
	

@onready var player = $"../Player"
@onready var riddle_focus = $"../RiddleArea/RiddleFocusPoint"

var normal_zoom := Vector2(1, 1)
var riddle_zoom := Vector2(2, 2)
var tween: Tween

func start_riddle():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "position", riddle_focus.global_position, 0.8)
	tween.tween_property(self, "zoom", riddle_zoom, 0.8)

func end_riddle():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "zoom", normal_zoom, 0.8)
	tween.tween_property(self, "position", player.global_position, 0.8)
