extends Sprite2D
func disperse_clouds():
	print("CLOUD SCRIPT: Animation started!") # Check the Output panel for this message
	var tween = create_tween().set_parallel(true) 

	tween.tween_property(self, "position:x", self.position.x + 400, 2.0).set_trans(Tween.TRANS_SINE)
	# 2. FADE: Make them vanish
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	tween.chain().finished.connect(func(): self.queue_free())


func _on_worllddsss_ennnddd_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
