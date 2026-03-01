extends Control

@onready var video_player = $VideoStreamPlayer
# تأكد إن اسم الزرار عندك في المشهد هو Btn_Skip زي ما مكتوب هنا
@onready var skip_button = $Btn_Skip 

func _ready():
	# 1. نوقف موسيقى الخلفية عشان نسمع الفيديو
	if MusicManager.has_node("AudioStreamPlayer"):
		MusicManager.get_node("AudioStreamPlayer").stop()
	elif MusicManager.get_child_count() > 0:
		var sound_node = MusicManager.get_child(0)
		if sound_node.has_method("stop"):
			sound_node.stop()

	# 2. نخفي زرار التخطي أول ما المشهد يفتح

	# 3. نشغل فيديو المقدمة (حط مسار الفيديو بتاعك هنا)
	var video_path = "res://Assets/videos/Intro Final.ogv" 
	if FileAccess.file_exists(video_path):
		video_player.stream = load(video_path)
		video_player.play()
	
	# 4. نشغل عداد 5 ثواني عشان نظهر الزرار
	show_skip_button_after_delay()

# دالة الانتظار 5 ثواني
func show_skip_button_after_delay():
	await get_tree().create_timer(5.0).timeout
	skip_button.show()

# دالة الخروج من الكاتسين (سواء الفيديو خلص أو دوسنا تخطي)
func go_to_next_screen():
	video_player.stop()
	
	# نشغل موسيقى الخلفية تاني قبل ما نمشي من الشاشة دي
	if MusicManager.has_node("AudioStreamPlayer"):
		MusicManager.get_node("AudioStreamPlayer").play()
	elif MusicManager.get_child_count() > 0:
		var sound_node = MusicManager.get_child(0)
		if sound_node.has_method("play"):
			sound_node.play()
			
	# النقل لشاشة اختيار الشخصية
	get_tree().call_deferred("change_scene_to_file", "res://character_select.tscn")

# ---------------------------------------------------------
# دي الإشارات (Signals) اللي متوصلة من بره

# الحالة 1: الفيديو خلص لوحده
func _on_video_stream_player_finished():
	go_to_next_screen()

# الحالة 2: اللاعب داس تخطي



func _on_skip_btn_pressed() -> void:
	go_to_next_screen()
