extends Area2D


@export var required_stars := 3
@onready var my_sprite = $Sprite2D2
@onready var portal_asset = $"../portal"

func _ready():
	my_sprite.visible = false
	portal_asset.visible = false
	portal_asset.process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if body.stars_collected >= required_stars:
		my_sprite.visible = true
		reveal_asset()
	else:
		print("You need more stars")
		
func reveal_asset():
	portal_asset.visible = true
	# Enable the logic/collision so the player can now touch it
	portal_asset.process_mode = Node.PROCESS_MODE_INHERIT
	print("A secret portal has appeared!")
	
	# IMPORTANT WARNING ABOUT queue_free():
	# If you use queue_free(), it deletes this trigger area completely. 
	# Because 'my_sprite' is attached to this area, the sprite will instantly vanish too!
	# If you want the sprite to stay visible on screen, we should disable the collision 
	# instead of deleting the whole node.
	$CollisionShape2D.set_deferred("disabled", true)
