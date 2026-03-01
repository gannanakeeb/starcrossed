extends Node

@onready var hint_layer = $hint # MAKE SURE THIS NAME IS EXACT
@onready var minigame_container = $portal/MinigameContainer

# CHANGE THIS to the actual file path of your phone minigame!
var minigame_scene_path = "res://scenes/maingame.tscn"

func _ready():
	# This part checks if the node exists so it doesn't crash
	if hint_layer:
		hint_layer.visible = false
	else:
		print("ERROR: I can't find the node named 'hint'!")

func _on_portal_body_entered(body: Node2D) -> void:
	print("Portal touched! Loading minigame...")
	var minigame_resource = load(minigame_scene_path)
	
	if minigame_resource:
		var minigame_instance = minigame_resource.instantiate()
		
		# This 'plugs in' the win signal to the function below
		minigame_instance.connect("minigame_won", _on_minigame_finished)
		
		minigame_container.add_child(minigame_instance)
	else:
		print("ERROR: Could not find the minigame file at " + minigame_scene_path)
	

func _on_minigame_finished():
	print("Signal received! Deleting game and showing hint...")
	
	# Remove the minigame
	for child in minigame_container.get_children():
		child.queue_free()
	
	# Show the blue phone hint
	hint_layer.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_back_button_pressed():
	hint_layer.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Back in Gasser's world!")
