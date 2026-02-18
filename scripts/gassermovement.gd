extends CharacterBody2D  # السكربت مربوط على لاعب من نوع CharacterBody2D

@export var speed: float = 400.0  # سرعة الحركة الأفقية للاعب
@export var jump_velocity: float = -800.0  # قوة القفز (سالب لأن الاتجاه للأعلى)
@export var gravity: float = 980.0  # قوة الجاذبية اللي تنزل اللاعب للأسفل

@export var main_character: CharacterBody2D = null  # إذا هذا اللاعب تابع لشخصية ثانية (Follower)
@export var teleport_distance: float = 500.0  # إذا ابتعد أكثر من هاي المسافة، يسوي teleport
@export var follow_distance: float = 150  # المسافة اللي يحافظ عليها من الشخصية الرئيسية

@export var sfx_jump: AudioStream  # صوت القفز
@export var sfx_walking: AudioStream  # صوت المشي
@export var sprite: AnimatedSprite2D  # يمسك الـ AnimatedSprite2D للأنيميشن
@export var spawn_point: Marker2D  # نقطة respawn، يربطها من الـ Inspector

@onready var sfx_player: AudioStreamPlayer2D = $sfx_gasser  # مشغل الأصوات داخل اللاعب

var footstep_frames: Array = [1, 3]  # الإطارات اللي يشتغل بيها صوت المشي
var stars_collected: int = 0  # عدد النجوم اللي جمعها اللاعب


func _physics_process(delta: float) -> void:  # تشتغل كل فريم فيزيائي
	# تطبيق الجاذبية
	if not is_on_floor():  # إذا اللاعب مو على الأرض
		velocity.y += gravity * delta  # نضيف جاذبية للسرعة العمودية

	var direction := 0.0  # اتجاه الحركة (يمين أو يسار)

	if main_character == null:  # إذا هذا اللاعب هو الرئيسي
		# تحكم يدوي
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			play_sfx(sfx_jump, -5)  # تشغيل صوت القفز
			velocity.y = jump_velocity  # تنفيذ القفزة

		direction = Input.get_axis("ui_left", "ui_right")  # قراءة حركة اليمين واليسار

	else:  # نظام Follower
		var distance_to_main := global_position.distance_to(main_character.global_position)

		if distance_to_main > teleport_distance:
			global_position = main_character.global_position + Vector2(-50, 0)  # teleport
			velocity = Vector2.ZERO
		else:
			var horizontal_distance := main_character.global_position.x - global_position.x
			if abs(horizontal_distance) > follow_distance:
				direction = sign(horizontal_distance)  # يمين أو يسار
				if main_character.global_position.y < global_position.y - 20 and is_on_floor():
					velocity.y = jump_velocity  # قفزة صغيرة إذا كان قريب للأعلى


	# الحركة الأفقية
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)  # تبطئة الحركة تدريجياً

	# التحكم بالأنيميشن
	if sprite:
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0  # قلب الكاركتر يمين/يسار

		if not is_on_floor():
			sprite.play("jump")
		elif velocity.x != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")

	move_and_slide()  # تنفيذ الحركة الفعلية


# تشغيل صوت مع تحكم بالمستوى
func play_sfx(stream: AudioStream, volume_db: float = 0):
	if stream == null:
		return
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.play()


# نظام صوت خطوات المشي
func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation != "walk":
		return
	if sprite.frame in footstep_frames:
		play_sfx(sfx_walking, -10)


func add_star(amount := 1):
	stars_collected += amount
	print("stars:", stars_collected)
	if stars_collected >= 3:
		emit_signal("collected_three_stars")


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass  # حاليا ما يسوي شي


# دالة الـ respawn، الـ death zone يستدعيها لما اللاعب يلمسها
func respawn():
	if spawn_point:
		position = spawn_point.global_position  # ارجع اللاعب لنقطة البداية
	velocity = Vector2.ZERO  # وقف الحركة عند الـ respawn
