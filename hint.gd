extends CanvasLayer
func _on_back_hint_button_pressed() -> void:
	self.visible = false
	
	# Put the mouse back to game mode (if your game is first-person/locked)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	
	# Resume any game logic if you paused it
	get_tree().paused = false
	
