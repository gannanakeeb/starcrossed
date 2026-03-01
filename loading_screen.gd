extends Control

func _load_level():

	
	if GameManager.player_choice == "WIZARD":
		get_tree().change_scene_to_file("res://مسار_ليفل_الساحر_هنا.tscn")
		
	# --- ليفلات الأطفال التلاتة ---
	
	elif GameManager.player_choice == "KID_1":
		# الولد الأول
		get_tree().change_scene_to_file("res://مسار_ليفل_الولد_الأول.tscn")
		
	elif GameManager.player_choice == "KID_2":
		# الولد التاني
		get_tree().change_scene_to_file("res://مسار_ليفل_الولد_التاني.tscn")
		
	elif GameManager.player_choice == "KID_3":
		# البنت الساحرة
		get_tree().change_scene_to_file("res://مسار_ليفل_البنت.tscn")
