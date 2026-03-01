extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_video_stream_player_finished():
	# الفيديو خلص؟ يلا نشوف إحنا مين ونفتح الليفل بتاعه
	
	if GameManager.player_choice == "KID_1":
		get_tree().change_scene_to_file("res://Levels/Level_Kid1.tscn")
		
	elif GameManager.player_choice == "KID_2":
		get_tree().change_scene_to_file("res://Levels/Level_Kid2.tscn")
		
	elif GameManager.player_choice == "KID_3":
		get_tree().change_scene_to_file("res://Levels/Level_Kid3.tscn")
