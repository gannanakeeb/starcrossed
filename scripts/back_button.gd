extends CanvasLayer

func _on_back_button_pressed():
	# Unpause the game engine before switching
	get_tree().paused = false
	
	# Return to your main world scene
	# Change the path below to your actual main game scene file
	get_tree().change_scene_to_file("res://Scenes/MainWorld.tscn")
