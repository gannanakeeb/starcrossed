@tool
extends Area2D

@export_file("*.txt") var conversation_file: String:
	set(value):
		conversation_file = value
		_refresh_from_file()

@export var camera_targets: Array[Node2D] = []
var _line_labels: Array[String] = []

var dialogue_system: DialogueSystem
var is_done: bool = false

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	for label in _line_labels:
		props.append({
			"name": label,
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_EDITOR,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": "Node2D",
		})
	return props

func _get(property: StringName) -> Variant:
	var idx := _line_labels.find(str(property))
	if idx >= 0:
		return camera_targets[idx] if idx < camera_targets.size() else null
	return null

func _set(property: StringName, value) -> bool:
	var idx := _line_labels.find(str(property))
	if idx >= 0:
		while camera_targets.size() <= idx:
			camera_targets.append(null)
		camera_targets[idx] = value
		return true
	return false

func _ready():
	if Engine.is_editor_hint():
		_refresh_from_file()
		return

	body_entered.connect(_on_body_entered)
	dialogue_system = _find_dialogue_system(get_tree().root)
	if dialogue_system == null:
		push_error("DialogueSystem not found in scene!")

func _refresh_from_file():
	if conversation_file == "" or not FileAccess.file_exists(conversation_file):
		_line_labels.clear()
		notify_property_list_changed()
		return

	var file = FileAccess.open(conversation_file, FileAccess.READ)
	if file == null:
		return

	var labels: Array[String] = []
	while not file.eof_reached():
		var raw = file.get_line().strip_edges()
		if raw == "":
			continue
		var parts = raw.split(",", true, 1)
		if parts.size() >= 2:
			var char_name = parts[0].strip_edges().capitalize()
			var text = parts[1].strip_edges()
			labels.append("[" + str(labels.size()) + "] " + char_name + ": " + text)
	file.close()

	_line_labels = labels

	while camera_targets.size() < _line_labels.size():
		camera_targets.append(null)

	notify_property_list_changed()

func _find_dialogue_system(node: Node) -> DialogueSystem:
	if node is DialogueSystem:
		return node
	for child in node.get_children():
		var result = _find_dialogue_system(child)
		if result:
			return result
	return null

func _on_body_entered(body):
	if is_done:
		return

	is_done = true

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

	var line_index: int = 0

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "":
			continue

		var parts = line.split(",", true, 1)
		if parts.size() >= 2:
			var character_name = parts[0].strip_edges().capitalize()
			var dialogue_text = parts[1].strip_edges()

			var target: Node2D = null
			if line_index < camera_targets.size():
				target = camera_targets[line_index]

			conversation.append(DialogueSystem.DialogueEntry.new(character_name, dialogue_text, target))
			line_index += 1

	file.close()
	return conversation
	
	
