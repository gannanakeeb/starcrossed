extends Area2D

# 1. Define where your mini-game scene file is located
# CHANGE THIS PATH to match your actual mini-game file location!
var snake_scene = preload("res://scenes/maingame.tscn")
@export var player: CharacterBody2D

func _on_body_entered(body):
	# 2. Security Check: Make sure it's actually the Player touching it
	# (Assumes your player node is named "Player")
	if body.is_in_group("player"):
		print("Player touched the portal! Loading mini-game...")
		$CollisionShape2D.set_deferred("disabled", true)
		# 3. Optional: If you have an 'open' animation, play it here
		# $AnimatedSprite2D.play("open")
		# await $AnimatedSprite2D.animation_finished
		# 4. Switch the scene safely
		call_deferred("load_minigame", body.global_position)

func load_minigame(player_pos):
	# This command swaps the current level for the mini-game scene
		# 2. Create a copy of the snake game
	var minigame = snake_scene.instantiate()
	
	# 3. Add it directly on top of the current game screen
	get_tree().root.add_child(minigame)
	minigame.scale = Vector2(0.9, 0.9)
	# 4. Pause the main game (so enemies don't attack you while you play snake!)
	get_tree().paused = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false  # متخفي في البداية
	# Player في نفس الأب
	
	if player != null:
		player.connect("collected_three_stars", Callable(self, "_on_three_stars_collected"))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_three_stars_collected():
	visible = true
	print("RiddleCode shown!")
