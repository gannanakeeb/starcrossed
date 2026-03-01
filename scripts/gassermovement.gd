extends CharacterBody2D  # السكريبت مربوط على لاعب من نوع CharacterBody2D

signal collected_three_stars

@export var speed: float = 400.0  # سرعة الحركة الأفقية
@export var jump_velocity: float = -800.0  # قوة القفز (سالب لأن الاتجاه للأعلى)
@export var gravity: float = 980.0  # قوة الجاذبية

@export var main_character: CharacterBody2D = null  # لو اللاعب تابع لشخصية تانية
@export var teleport_distance: float = 500.0  # لو بعد أكتر من كده يعمل teleport
@export var follow_distance: float = 150  # المسافة اللي يحافظ عليها من الشخصية الرئيسية

@export var sfx_jump: AudioStream  # صوت القفز
@export var sprite: AnimatedSprite2D  # الأنيميشن بتاع الكاركتر
@export var spawn_point: Marker2D  # نقطة الـ respawn

@onready var sfx_player: AudioStreamPlayer2D = $sfx_gasser  # مشغل الأصوات
@onready var sibling = get_node("../variable_dialogue") 
var footstep_frames: Array = [1, 3]  # الفريمات اللي هيشتغل فيها صوت الخطوة (2 و 4 لأن جودو بيبدأ من 0)
var stars_collected: int = 0  # عدد النجوم اللي اتجمعت

# الـ 8 أصوات بالترتيب، هيشتغلوا واحد ورا التاني وبعد الـ 8 يرجع من الأول
var footsteps: Array = [
	preload("res://sfx/foot steps sfx/foot 1 .wav"),
	preload("res://sfx/foot steps sfx/foot 2 .wav"),
	preload("res://sfx/foot steps sfx/foot 3 .wav"),
	preload("res://sfx/foot steps sfx/foot 4.wav"),
	preload("res://sfx/foot steps sfx/foot 5.wav"),
	preload("res://sfx/foot steps sfx/foot 6.wav"),
	preload("res://sfx/foot steps sfx/foot 7.wav"),
	preload("res://sfx/foot steps sfx/foot 8.wav"),
]
var step_index: int = 0  # رقم الصوت الحالي في الـ array


func _physics_process(delta: float) -> void:  # بتشتغل كل فريم فيزيائي

	# لو اللاعب في الهواء نطبق الجاذبية
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := 0.0  # اتجاه الحركة

	if main_character == null:  # لو ده اللاعب الرئيسي
		# لو ضغط زر القفز وهو على الأرض
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			play_sfx(sfx_jump, -5)  # شغّل صوت القفز
			velocity.y = jump_velocity  # نفّذ القفزة

		direction = Input.get_axis("ui_left", "ui_right")  # اقرأ حركة يمين ويسار

	else:  # لو ده follower بيتبع شخصية تانية
		var distance_to_main := global_position.distance_to(main_character.global_position)

		if distance_to_main > teleport_distance:
			# لو بعد أوي عن الشخصية الرئيسية، teleport جنبها على طول
			global_position = main_character.global_position + Vector2(-50, 0)
			velocity = Vector2.ZERO
		else:
			var horizontal_distance := main_character.global_position.x - global_position.x
			# لو بعد عن الشخصية الرئيسية أكتر من follow_distance، يمشي ناحيتها
			if abs(horizontal_distance) > follow_distance:
				direction = sign(horizontal_distance)
				# لو الشخصية الرئيسية فوقيه، يقفز
				if main_character.global_position.y < global_position.y - 20 and is_on_floor():
					velocity.y = jump_velocity

	# لو في اتجاه، امشي
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)  # وقّف الحركة تدريجياً

	if sprite:
		# قلّب الكاركتر حسب اتجاه الحركة
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0

		# شغّل الأنيميشن المناسب
		if not is_on_floor():
			sprite.play("jump")
		elif velocity.x != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()  # نفّذ الحركة الفعلية


# دالة تشغيل أي صوت مع تحكم في الصوت
func play_sfx(stream: AudioStream, volume_db: float = 0):
	if stream == null:
		return
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.play()


# بتشتغل أوتوماتيك كل ما الفريم يتغير في الأنيميشن
func _on_animated_sprite_2d_frame_changed() -> void:
	# لو مش في أنيميشن المشي، مشغلش صوت
	if sprite.animation != "walk":
		return
	# لو الفريم الحالي هو 2 أو 4 (1 أو 3 في جودو)، شغّل صوت خطوة
	if sprite.frame in footstep_frames:
		sfx_player.stream = footsteps[step_index]  # اختار الصوت الحالي
		sfx_player.volume_db = -5  # مستوى الصوت
		sfx_player.pitch_scale = randf_range(0.95, 1.05)  # تغيير بسيط في النبرة عشان ميبانش مكرر
		sfx_player.play()
		step_index = (step_index + 1) % footsteps.size()  # روّح على الصوت الجاي، لو خلصوا ارجع من الأول


# دالة لإضافة نجوم
func add_star(amount := 1):
	stars_collected += amount
	print("stars:", stars_collected)
	if stars_collected >= 3:

		if sibling:
			print("Position changed successfully")
			sibling.global_position = global_position
		emit_signal("collected_three_stars")  # ابعت سيجنال لما يتجمع 3 نجوم


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass  # فاضية دلوقتي، تقدر تضيف فيها كود لما حاجة تلمس اللاعب


# دالة الـ respawn، بتتستدعى لما اللاعب يلمس منطقة الموت
func respawn():
	print("RESPAWN CALLED!")
	var spawn = get_tree().get_first_node_in_group("spawn_point")  # دور على نقطة الـ spawn في السين
	if spawn:
		print("Spawn global_position: ", spawn.global_position)
		print("Player position before: ", global_position)
		global_position = spawn.global_position  # نقّل اللاعب لنقطة الـ spawn
		print("Player position after: ", global_position)
	else:
		print("ERROR: No spawn point found!")  # لو مفيش spawn point هيطبع error
	velocity = Vector2.ZERO  # وقّف حركة اللاعب بعد الـ respawn
