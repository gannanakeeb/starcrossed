extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var gravity: float = 980.0
@onready var sfx_walk: AudioStreamPlayer = $sfx_walk

@export var main_character: CharacterBody2D = null
@export var teleport_distance: float = 500.0
@export var follow_distance: float = 150

@export var sprite: AnimatedSprite2D = null

var stars_collected: int = 0

func _physics_process(delta: float) -> void:

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := 0.0

	if main_character == null:
		# Player-controlled movement (this is the main character)
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity

		direction = Input.get_axis("ui_left", "ui_right")
	else:
		# Follower AI behavior
		var distance_to_main := global_position.distance_to(main_character.global_position)

		# Teleport if too far away
		if distance_to_main > teleport_distance:
			global_position = main_character.global_position + Vector2(-50, 0)
			velocity = Vector2.ZERO 
		else:
			# Follow the main character
			var horizontal_distance := main_character.global_position.x - global_position.x

			if abs(horizontal_distance) > follow_distance:
				direction = sign(horizontal_distance)

				# Jump if main character is above and we're on the floor
				if main_character.global_position.y < global_position.y - 20 and is_on_floor():
					velocity.y = jump_velocity

	# Apply horizontal movement
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Update sprite animation and direction
	if sprite != null:
		# Flip sprite based on velocity direction
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0

		# Set animation based on state
		if not is_on_floor():
			if velocity.y > 0:
				sprite.play("jump")
				sfx_walk.play()
		elif velocity.x != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()

func add_star(amount := 1):
	stars_collected += amount
	print("stars", stars_collected)

	if stars_collected >= 3:
		emit_signal("collected_three_stars")
