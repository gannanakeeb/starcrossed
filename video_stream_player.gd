extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func stop_music():
	# الكود ده ذكي: هيدور على مشغل الصوت ويوقفه أياً كان مكانه
	if has_node("AudioStreamPlayer"):
		$AudioStreamPlayer.stop()
	else:
		stop()
