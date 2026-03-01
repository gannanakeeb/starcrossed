extends Control

func _load_level():

	
	if GameManager.player_choice == "WIZARD":
		get_tree().change_scene_to_file("res://scenes/gassermap.tscn")
		
	# --- ليفلات الأطفال التلاتة ---
	
	elif GameManager.player_choice == "KID_1":
		# الولد الأول
		get_tree().change_scene_to_file("res://scenes/level 1 children pov.tscn")
		
	elif GameManager.player_choice == "KID_2":
		# الولد التاني
		get_tree().change_scene_to_file("res://scenes/level 1 children pov.tscn")
		
	elif GameManager.player_choice == "KID_3":
		# البنت الساحرة
		get_tree().change_scene_to_file("res://scenes/level 1 children pov.tscn")
