extends Camera2D

@export var target: Node2D = null
@export var follow_smoothing: float = 5.0

func _process(delta: float) -> void:
	if target != null:
		global_position = global_position.lerp(target.global_position, follow_smoothing * delta)

@onready var player = $"../Player"
@onready var riddle_focus = $"../RiddleArea/RiddleFocusPoint"

var _follow_target: Node2D = null

func _ready() -> void:
	_follow_target = target  # save whatever was assigned in the inspector
	var dialogue_system := _find_dialogue_system(get_tree().root)
	if dialogue_system:
		dialogue_system.camera_pan_requested.connect(_on_camera_pan_requested)

func _find_dialogue_system(node: Node) -> DialogueSystem:
	if node is DialogueSystem:
		return node
	for child in node.get_children():
		var result = _find_dialogue_system(child)
		if result:
			return result
	return null

func _on_camera_pan_requested(pan_target: Node2D) -> void:
	if tween:
		tween.kill()
	if pan_target == null:
		target = _follow_target  # restore original follow target from inspector
		return
	target = null  # stop following player so _process doesn't fight the tween
	tween = create_tween()
	tween.tween_property(self, "global_position", pan_target.global_position, 0.8)

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
