extends Control

func _on_btn_wizard_pressed():
	GameManager.player_choice = "WIZARD"
	# الساحر هيروح لشاشة التحميل فوراً
	get_tree().change_scene_to_file("res://wizard_loading.tscn") 


# لما ندوس على زرار الأطفال
func _on_btn_kids_pressed():
	GameManager.player_choice = "KIDS"
	# الأطفال هيروحوا لشاشة جديدة هنعملها حالا (هنسميها kids_select)
	get_tree().change_scene_to_file("res://kids_select.tscn")


func _on_btn_back_pressed() -> void:
# الكود ده هيرجعك للقائمة الرئيسية
	get_tree().change_scene_to_file("res://main_menu.tscn")
