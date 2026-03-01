extends CanvasLayer

func _on_back_button_pressed():
	# Hide the hint
	self.visible = false
	
	# Put the mouse back to game mode (if your game is first-person/locked)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	# Resume any game logic if you paused it
	get_tree().paused = false
