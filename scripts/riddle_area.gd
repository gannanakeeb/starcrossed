extends Area2D


@export var required_stars := 3
@export var riddle_ui: CanvasLayer
@onready var my_sprite = $Sprite2D
func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if body.stars_collected >= required_stars:
		my_sprite.visible = true
	else:
		print("You need more stars")
		

func _ready():
	my_sprite.visible = false
	
	
	
	
