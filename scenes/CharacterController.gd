extends CharacterBody2D
@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var gravity: float = 980.0
@export var main_character: CharacterBody2D = null
@export var teleport_distance: float = 500.0
@export var follow_distance: float = 150
@export var sfx_jump: AudioStream
@export var sprite: AnimatedSprite2D
@export var spawn_point: Marker2D
@onready var sfx_player: AudioStreamPlayer2D = $child_sfx
@onready var sfx_footsteps: AudioStreamPlayer2D = $child_sfx_footsteps

var footstep_frames: Array = [1, 2, 4]  # changed from [1, 3]
var stars_collected: int = 0
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

	if sprite:
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0
		if not is_on_floor():
			sprite.play("jump")
		elif velocity.x != 0:
			sprite.play("default")
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


func play_sfx(stream: AudioStream, volume_db: float = 0):
	if stream == null:
		return
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.play()


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "default":
		if sprite.frame in footstep_frames:
			sfx_footsteps.stream = footsteps[step_index]
			sfx_footsteps.volume_db = -5
			sfx_footsteps.pitch_scale = randf_range(0.95, 1.05)
			sfx_footsteps.play()
			step_index = (step_index + 1) % footsteps.size()


func add_star(amount := 1):
	stars_collected += amount
	print("stars:", stars_collected)
	if stars_collected >= 3:
		emit_signal("collected_three_stars")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass


func respawn():
	print("RESPAWN CALLED!")
	var spawn = get_tree().get_first_node_in_group("spawn_point")
	if spawn:
		global_position = spawn.global_position
	else:
		print("ERROR: No spawn point found!")
	velocity = Vector2.ZERO


func _on_death_zone_body_entered(body: Node2D) -> void:
	print("DEATH ZONE HIT BY: ", body.name)
	if body == self:
		respawn()
