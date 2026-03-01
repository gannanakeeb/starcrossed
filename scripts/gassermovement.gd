extends CharacterBody2D
var stars_collected := 0
@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var gravity: float = 980.0
@export var main_character: CharacterBody2D = null
@export var teleport_distance: float = 500.0
@export var follow_distance: float = 150
@export var sprite: AnimatedSprite2D = null

@onready var sfx_player: AudioStreamPlayer2D = $sfx_gasser
@onready var sfx_footsteps: AudioStreamPlayer2D = $gasser_sfx_footsteps

var footsteps: Array = [
	preload("res://sfx/foot steps sfx/foot  (1).wav"),
	preload("res://sfx/foot steps sfx/foot  (2).wav"),
	preload("res://sfx/foot steps sfx/foot  (3).wav"),
	preload("res://sfx/foot steps sfx/foot  (4).wav"),
	preload("res://sfx/foot steps sfx/foot  (5).wav"),
	preload("res://sfx/foot steps sfx/foot  (6).wav"),
	preload("res://sfx/foot steps sfx/foot  (7).wav"),
	preload("res://sfx/foot steps sfx/foot  (8).wav"),
]
var step_index: int = 0

var jump_sfx: Array = [
	preload("res://sfx/jump sfx/jump 1 (1).wav"),
	preload("res://sfx/jump sfx/jump 1 (2).wav"),
	preload("res://sfx/jump sfx/jump 1 (3).wav"),
	preload("res://sfx/jump sfx/jump 1 (4).wav"),
]
var death_sfx: AudioStream = preload("res://sfx/Death sfx 01.wav")

var jump_pair_index: int = 0
var was_on_floor: bool = true


func _physics_process(delta: float) -> void:
	var on_floor_last_frame = was_on_floor

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := 0.0

	if main_character == null:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity
		direction = Input.get_axis("ui_left", "ui_right")
	else:
		var distance_to_main := global_position.distance_to(main_character.global_position)
		if distance_to_main > teleport_distance:
			global_position = main_character.global_position + Vector2(-50, 0)
			velocity = Vector2.ZERO
		else:
			var horizontal_distance := main_character.global_position.x - global_position.x
			if abs(horizontal_distance) > follow_distance:
				direction = sign(horizontal_distance)
				if main_character.global_position.y < global_position.y - 20 and is_on_floor():
					velocity.y = jump_velocity

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if sprite != null:
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0
		if not is_on_floor():
			if velocity.y < 0:
				sprite.play("jump")
		elif velocity.x != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()

	if on_floor_last_frame and not is_on_floor():
		sfx_player.stream = jump_sfx[jump_pair_index * 2]
		sfx_player.volume_db = -5
		sfx_player.play()

	if not on_floor_last_frame and is_on_floor():
		sfx_player.stream = jump_sfx[jump_pair_index * 2 + 1]
		sfx_player.volume_db = -5
		sfx_player.play()
		jump_pair_index = (jump_pair_index + 1) % 2

	was_on_floor = is_on_floor()


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "walk":
		if sprite.frame == 0 or sprite.frame == 2:
			sfx_footsteps.stream = footsteps[step_index]
			sfx_footsteps.volume_db = 0
			sfx_footsteps.play()
			step_index = (step_index + 1) % footsteps.size()


func add_star(amount := 1):
	stars_collected += amount
	print("stars", stars_collected)


func respawn():
	var fade = get_tree().get_first_node_in_group("fade")
	if fade:
		fade.fade_out(0.5)
	sfx_player.stream = death_sfx
	sfx_player.volume_db = 0
	sfx_player.play()
	var spawn = get_tree().get_first_node_in_group("spawn_point")
	if spawn:
		global_position = spawn.global_position
	else:
		print("ERROR: No spawn point found!")
	velocity = Vector2.ZERO
	if fade:
		fade.fade_in_delayed(0.5)


func _on_death_zone_body_entered(body: Node2D) -> void:
	print("DEATH ZONE HIT BY: ", body.name)
	if body == self:
		respawn()
