extends Sprite2D  # أو TextureRect لو UI

func _ready():
	visible = false  # متخفي في البداية

	# Player في نفس الأب
	var player = get_node("gasser")
	if player != null:
		player.connect("collected_three_stars", Callable(self, "_on_three_stars_collected"))

func _on_three_stars_collected():
	visible = true
	print("RiddleCode shown!")
