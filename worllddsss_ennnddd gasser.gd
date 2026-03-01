extends Area2D
@export var video_player: VideoStreamPlayer
@export var coming_soon_screen: Control 
@export var black_backdrop: ColorRect # <--- ADD THIS NEW VARIABLE

var triggered: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	# Hide everything at the start
	if video_player: video_player.hide()
	if coming_soon_screen: coming_soon_screen.hide()
	if black_backdrop: black_backdrop.hide() # <--- Hide the black at start



func _on_body_entered(body):
	print(body_entered)
	if triggered or (body.name != "gasser"):
		return
	triggered = true
	play_end_sequence()
	
func play_end_sequence():
	if not video_player or not black_backdrop: return
	
	# 1. Show the black background and the video at the same time
	black_backdrop.modulate.a = 0.0
	video_player.modulate.a = 0.0
	
	black_backdrop.show()
	video_player.show()
	video_player.play()
	
	# 2. Fade them both in together
	var fade_in = create_tween().set_parallel(true) # .set_parallel lets them fade at once
	fade_in.tween_property(black_backdrop, "modulate:a", 1.0, 1.0)
	fade_in.tween_property(video_player, "modulate:a", 1.0, 1.0)
	
	if not video_player.finished.is_connected(_on_video_finished):
		video_player.finished.connect(_on_video_finished)

func _on_video_finished():
	# --- FADE OUT VIDEO ---
	var fade_out = create_tween()
	fade_out.tween_property(video_player, "modulate:a", 0.0, 1.5)
	
	fade_out.finished.connect(func():
		video_player.hide()
		# The black backdrop STAYS visible while the text fades in
		if coming_soon_screen:
			coming_soon_screen.show()
			coming_soon_screen.modulate.a = 0
			var text_fade = create_tween()
			text_fade.tween_property(coming_soon_screen, "modulate:a", 1.0, 1.5)
	)
	
