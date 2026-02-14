extends CanvasLayer

@onready var riddle_ui = $"../UI/riddle/RiddleUI"
@onready var bg = $Sprite2D
@onready var marker = $"../Marker2D"
@onready var cam = $"../Camera2D" 
  

var last_state := false
var original_zoom := Vector2.ONE
var original_position := Vector2.ZERO

func _ready():
	visible = false
	bg.modulate.a = 0
	last_state = false
	original_zoom = cam.zoom
	original_position = cam.position

func _process(delta):
	if riddle_ui.visible != last_state:
		last_state = riddle_ui.visible
		if last_state:
			fade_in()
			zoom_to_marker()
		else:
			fade_out()
			zoom_reset()

func fade_in():
	visible = true
	bg.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 1.0, 1.0)

func fade_out():
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.0, 1.0)
	tween.finished.connect(func():
		visible = false)

func zoom_to_marker():
	var tween = create_tween()
	tween.tween_property(cam, "zoom", Vector2(0.5, 0.5), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cam, "position", marker.global_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func zoom_reset():
	var tween = create_tween()
	tween.tween_property(cam, "zoom", original_zoom, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(cam, "position", original_position, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
