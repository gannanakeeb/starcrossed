extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var gravity: float = 980.0

@export var main_character: CharacterBody2D = null
@export var teleport_distance: float = 500.0
@export var follow_distance: float = 150

@export var sfx_jump: AudioStream
@export var sfx_walking: AudioStream

@export var sprite: AnimatedSprite2D

@onready var sfx_player: AudioStreamPlayer2D = $sfx_gasser

var footstep_frames: Array = [1, 3]
var stars_collected: int = 0


func _physics_process(delta: float) -> void:

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := 0.0

	if main_character == null:
		# Player-controlled movement
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			play_sfx(sfx_jump, -5)  # Jump صوت أخف شوي
			velocity.y = jump_velocity

		direction = Input.get_axis("ui_left", "ui_right")

	else:
		# Follower AI
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

	# Horizontal movement
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Animation handling
	if sprite:
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0

		if not is_on_floor():
			sprite.play("jump")
		elif velocity.x != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()


# 🔊 play_sfx مع تحكم في مستوى الصوت
func play_sfx(stream: AudioStream, volume_db: float = 0):
	if stream == null:
		return

	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.play()


# 🔥 Footstep system (لازم تكون موصل signal frame_changed)
func _on_animated_sprite_2d_frame_changed() -> void:

	if sprite.animation != "walk":
		return

	if sprite.frame in footstep_frames:
		play_sfx(sfx_walking, -5)  # Walking أصوات أخف


func add_star(amount := 1):
	stars_collected += amount
	print("stars:", stars_collected)

	if stars_collected >= 3:
		emit_signal("collected_three_stars")
