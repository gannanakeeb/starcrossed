extends Control


var correct_answer = ["ari", "ari", "pi", "aq" ,"scor" ,"aq" ,"ari" ,"pi"]
var player_answer = []
func _ready():
	visible = false
	for button in get_tree().get_nodes_in_group("zodiac buttons"):
		button.pressed.connect(_on_any_zodiac_pressed.bind(button.name))

func show_riddle():

	print("UI SCRIPT: show_riddle() was called successfully!") 
	visible = true
	RenderingServer.set_default_clear_color(Color.RED)
	player_answer.clear()

func hide_riddle():
	visible = false
	player_answer.clear()

func add_symbol(symbol: String):
	player_answer.append(symbol)
	print("Answer:", player_answer)


func _on_aq_pressed() -> void:
	add_symbol("aq") # Replace with function body.

func _on_pi_pressed() -> void:
	add_symbol("pi")# Replace with function body.

func _on_ari_pressed() -> void:
	add_symbol("ari")
	

func _on_tau_pressed() -> void:
	add_symbol("tau") # Replace with function body.

func _on_gem_pressed() -> void:
	add_symbol("gem") # Replace with function body.

func _on_can_pressed() -> void:
	add_symbol("can") # Replace with function body.

func _on_leo_pressed() -> void:
	add_symbol("leo") # Replace with function body.

func _on_vir_pressed() -> void:
	add_symbol("vir") # Replace with function body.

func _on_lib_pressed() -> void:
	add_symbol("lib")# Replace with function body.
	print("The button works!") # This will show up in the Output console at the bottom

func _on_scor_pressed() -> void:
	add_symbol("scor") # Replace with function body.

func _on_sag_pressed() -> void:
	add_symbol("sag") # Replace with function body.

func _on_cap_pressed() -> void:
	add_symbol("cap") # Replace with function body.
	
func _on_submit_button_pressed() -> void:
	if player_answer == correct_answer:
		print("Correct!")
		hide_riddle()
	else:
		print("Wrong answer")
		player_answer.clear()

func _on_any_zodiac_pressed(button_name: String):
	print("Logic Working! Player clicked: ", button_name)
	# Now you can use button_name (like "aq", "pi") to solve your riddle





	
 
