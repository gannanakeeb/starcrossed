extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Death zone touched by: ", body.name)
	if body.has_method("respawn"):
		print("Calling respawn on: ", body.name)
		body.respawn()
	else:
		print("Body doesn't have respawn method!")
