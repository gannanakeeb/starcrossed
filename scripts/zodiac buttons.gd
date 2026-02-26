extends TextureButton

# This script runs on EVERY button it is attached to
func _ready():
	# Connect signals via code so you don't have to do it manually in the editor
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_button_down():
	# "Press" effect: make it darker and slightly smaller
	self_modulate = Color(0.7, 0.7, 0.7)
	scale = Vector2(0.95, 0.95)

func _on_button_up():
	# Return to normal
	self_modulate = Color(1, 1, 1)
	scale = Vector2(1, 1)

func _on_mouse_entered():
	# "Hover" effect: make it glow slightly
	self_modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	# Return to normal when mouse leaves
	self_modulate = Color(1, 1, 1)
