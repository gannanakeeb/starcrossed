extends CanvasLayer

func _on_back_button_pressed():
	# Hide the pop-up
	self.visible = false
	
	# Unpause the game so the player can continue
	get_tree().paused = false
	
	# Optional: Remove the scroll from the world so they can't click it again
	# get_node("../Scroll").queue_free()
