extends Area2D
@onready var hint_ui = $"../hint" # Path to your CanvasLayer
var can_interact: bool = false # The "Safety Lock"
func _ready():
	visible = false # Hidden until score hits 100
	$CollisionShape2D.disabled = true

# This triggers when the Player's physics body touches the scroll
func _on_body_entered(body):
	if can_interact and body.is_in_group("player"):
		show_the_hint()
		
func activate_scroll():
	visible = true
	can_interact = true
	# Unlock the physics shape
	$CollisionShape2D.set_deferred("disabled", false)
	print("Scroll is now active and touchable!")
# This triggers if you want the player to CLICK the scroll with a mouse/finger
func show_the_hint():
	hint_ui.visible = true
	# Optional: Pause the game while looking at the hint
	get_tree().paused = true
