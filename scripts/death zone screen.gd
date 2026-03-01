extends CanvasLayer

@onready var fade_rect: ColorRect = $fade_rect

func fade_out(duration: float = 0.5):
	fade_rect.visible = true
	fade_rect.color = Color(40.0/255, 42.0/255, 59.0/255, 0)
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, duration)

func fade_in(duration: float = 0.5):
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, duration)
	await tween.finished
	fade_rect.visible = false

func fade_in_delayed(delay: float = 0.5):
	await get_tree().create_timer(delay).timeout
	await get_tree().create_timer(1.0).timeout
	fade_in()
