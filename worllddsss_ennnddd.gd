extends Area2D

@export var video_player: VideoStreamPlayer
@export var coming_soon_screen: Control # The ColorRect/Label container

var triggered: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	# Make sure the UI is hidden at start
	if video_player: video_player.hide()
	if coming_soon_screen: coming_soon_screen.hide()

func _on_body_entered(body):
	# Check if the player entered (adjust name to "nader" or "fares" as before)
	if triggered or (body.name != "nader" and body.name != "fares"):
		return
	
	triggered = true
	play_end_sequence()

func play_end_sequence():
	if not video_player: return
	
	# --- FADE IN ---
	video_player.modulate.a = 0.0 # Start invisible
	video_player.show()
	video_player.play()
	
	var fade_in = create_tween()
	fade_in.tween_property(video_player, "modulate:a", 1.0, 1.0) # Fade to visible over 1 second
	
	# Wait for the video to finish to trigger the Fade Out
	if not video_player.finished.is_connected(_on_video_finished):
		video_player.finished.connect(_on_video_finished)

func _on_video_finished():
	# --- FADE OUT ---
	var fade_out = create_tween()
	fade_out.tween_property(video_player, "modulate:a", 0.0, 1.5) # Fade to invisible over 1.5 seconds
	
	# After fading out, show the 'Coming Soon' screen
	fade_out.finished.connect(func():
		video_player.hide()
		if coming_soon_screen:
			coming_soon_screen.show()
			# You can even fade the Coming Soon text in here!
	)
	var tween = create_tween()
	coming_soon_screen.modulate.a = 0
	tween.tween_property(coming_soon_screen, "modulate:a", 1.0, 1.5)
