extends Area2D  # هذا السكربت مربوط على منطقة (منطقة ماء مثلاً)

@onready var water_sound = $AudioStreamPlayer2D  
# هذا يمسك عقدة الصوت داخل الـ Area2D لما يبدأ المشهد

var target_volume = -5  
# هذا مستوى الصوت اللي نريد نوصل له (بالديسيبل)

var fade_speed = 3.0  
# سرعة التلاشي (كلما زادت يصير الفيد أسرع)

func _ready():
	water_sound.volume_db = -5  
	# يحدد مستوى الصوت بالبداية

	water_sound.play()  
	# يشغل الصوت مباشرة أول ما يشتغل المشهد

func _process(delta):
	water_sound.volume_db = move_toward(
		water_sound.volume_db,  # الصوت الحالي
		target_volume,          # الصوت المطلوب
		fade_speed * 20.0 * delta  # سرعة التغيير التدريجي
	)
	# هذا يخلي الصوت ينتقل تدريجياً للقيمة المطلوبة (فيد ناعم)


func _on_body_entered(player: Node2D) -> void:
	pass  # هذا السطر ما يسوي شي (وجوده بس شكلي)
	print("ENTERED WATER")  # يطبع بالكونسول لما شي يدخل المنطقة


func _on_body_exited(player: Node2D) -> void:
	pass
	print("EXITED WATER")  # يطبع لما يطلع من المنطقة
