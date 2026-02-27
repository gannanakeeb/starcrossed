extends Area2D

@export_file("*.txt") var conversation_file: String
@export var cloud_node: Sprite2D

var dialogue_system: DialogueSystem
var is_done: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	# Automatically find DialogueSystem in the scene
	dialogue_system = _find_dialogue_system(get_tree().root)
	if dialogue_system == null:
		push_error("DialogueSystem not found in scene!")

func _find_dialogue_system(node: Node) -> DialogueSystem:
	if node is DialogueSystem:
		return node
	for child in node.get_children():
		var result = _find_dialogue_system(child)
		if result:
			return result
	return null

func _on_body_entered(body):
	print("Area2D: Something touched me! It was: ", body.name) # ADD THIS LINE
	if is_done or (body.name != "nader" and body.name != "fares"):
		return
	
	is_done = true
	if cloud_node and cloud_node.has_method("disperse_clouds"):
		cloud_node.disperse_clouds()
	# Mark as done
	# Load and start conversation
	if conversation_file != "" and dialogue_system:
		var conversation = load_conversation_from_file(conversation_file)
		dialogue_system.start(conversation)
	

func load_conversation_from_file(file_path: String) -> Array[DialogueSystem.DialogueEntry]:
	var conversation: Array[DialogueSystem.DialogueEntry] = []

	if not FileAccess.file_exists(file_path):
		push_error("Conversation file not found: " + file_path)
		return conversation

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open conversation file: " + file_path)
		return conversation

	while not file.eof_reached():
		var line = file.get_line().strip_edges()

		# Skip empty lines
		if line == "":
			continue

		# Parse line format: name,text
		var parts = line.split(",", true, 1)
		if parts.size() >= 2:
			var character_name = parts[0].strip_edges()
			var dialogue_text = parts[1].strip_edges()

			# Capitalize first letter to handle case sensitivity
			character_name = character_name.capitalize()

			# Create DialogueEntry using the dialogue system's inner class
			var entry = dialogue_system.DialogueEntry.new(character_name, dialogue_text)
			conversation.append(entry)

	file.close()
	return conversation
	
	
