extends Area2D

# 1. Define where your mini-game scene file is located
# CHANGE THIS PATH to match your actual mini-game file location!
var minigame_scene_path = "res://scenes/maingame.tscn"

func _on_body_entered(body):
	# 2. Security Check: Make sure it's actually the Player touching it
	# (Assumes your player node is named "Player")
	if body.is_in_group("player"):
		print("Player touched the portal! Loading mini-game...")
		
		# 3. Optional: If you have an 'open' animation, play it here
		# $AnimatedSprite2D.play("open")
		# await $AnimatedSprite2D.animation_finished
		# 4. Switch the scene safely
		call_deferred("load_minigame")

func load_minigame():
	# This command swaps the current level for the mini-game scene
	get_tree().change_scene_to_file("res://scenes/maingame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
