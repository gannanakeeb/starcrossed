extends Area2D


@export var required_stars := 3
@export var riddle_ui: Control
func _ready():
	riddle_ui.hide()
	print("Riddle UI reference:", riddle_ui)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return  
		
	print("👤 Player entered riddle area")

	print("Riddle Area check! Player has: ", body.stars_collected)
		
	if body.stars_collected >= required_stars:
		riddle_ui.show_riddle()
	else:
		print("You need more stars")
		
