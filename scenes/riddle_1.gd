extends Control

var correct_answer = ["ari", "ari", "pi", "aq" ,"scor" ,"aq" ,"ari" ,"pi"]
var player_answer = []
func _ready():
	visible = false
	for button in get_tree().get_nodes_in_group("zodiac buttons"):
		button.pressed.connect(_on_any_zodiac_pressed.bind(button.name))
		
	for container in $HBoxContainer.get_children():
		var btn = container.get_child(0) # Gets the TextureButton inside the Panel
		if btn is TextureButton:
			btn.pressed.connect(_on_zodiac_button_pressed.bind(btn))
			
	for container in $HBoxContainer2.get_children():
		var btn = container.get_child(0)
		if btn is TextureButton:
			btn.pressed.connect(_on_zodiac_button_pressed.bind(btn))
			
		$clear.pressed.connect(_on_clear_pressed)
		$back.pressed.connect(_on_back_pressed)

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
	# This function runs whenever any zodiac button is pressed
func _on_zodiac_button_pressed(button_node: TextureButton):
	var new_symbol = TextureRect.new()
	# 2. Give it the same texture as the button that was pressed
	new_symbol.texture = button_node.texture_normal
	new_symbol.custom_minimum_size = Vector2(50, 50)
	new_symbol.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# 4. Add it to your display container
	$"input display".add_child(new_symbol)
	print("Symbol added to screen: ", button_node.name)
	# Deletes EVERYTHING in the display
# Deletes only the LAST symbol added
func _on_back_pressed() :
	var symbols = $"input display".get_children()
	if symbols.size() > 0:
		var last_symbol = symbols[-1]
		last_symbol.queue_free()
		print("Last symbol removed.")

func _on_clear_pressed() :
	for child in $"input display".get_children():
		child.queue_free() # Safely removes the node from the scene
	print("All symbols cleared.")
	
