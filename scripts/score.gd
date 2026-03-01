extends Node2D
signal minigame_won 
# At the top of the score script
signal show_scroll_now


var score: int = 0  # We will use this to track the 20-point jumps

@onready var screen_size = get_viewport().size
@onready var win_popup = $"../winpopup"

func _ready():
	$"score text".position = Vector2(680, 750)
# Change this function to handle the math
func update_score(_snake_length):
	score += 20 
	# Update the label text with the new score
	$"score text".text = str(score)
	# Queue a redraw so the background box updates if needed
	if score >= 100:
		trigger_win()
	queue_redraw() 
func _draw():
	# Note: Ensure '$ScoreText' matches the actual name (you used "score text" above)
	var label_node =$"score text"
	var score_width =$"score text" .get_rect().size.x + label_node.get_combined_minimum_size().x - 20

	var bg_rect = Rect2(label_node.position.x-5 , label_node.position.y +5 , score_width, 40)
	
	# Drawing the background box
	draw_rect(bg_rect, Color8(166, 209, 60))
	draw_rect(bg_rect, Color8(56, 74, 12), false, 2.0) # Added '2.0' for line thickness
	

func trigger_win():
	print("You reached 100 points!")
	emit_signal("minigame_won")
	emit_signal("show_scroll_now")
	get_tree().paused = true 
	win_popup.visible = true
	# Find the Scroll and make it appear
	var scroll = %scroll
	if scroll:
		print("Scroll found! Activating...")
		scroll.activate_scroll() # This triggers the visible + physics unlock
		
		
