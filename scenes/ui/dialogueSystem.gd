extends Control
class_name DialogueSystem

# Character class
class Character:
	var sprite: Texture2D
	var color: String
	var listeners: Array[String]

	func _init(character_sprite: Texture2D, text_color: String, listener_names: Array[String] = []):
		sprite = character_sprite
		color = text_color
		listeners = listener_names

# Dictionary: Name -> Character
var characters: Dictionary = {
	"Nader": Character.new(preload("res://scenes/ui/nader face.png"), "#c64e4e", ["Fares", "Roaya"]),
	"Fares": Character.new(preload("res://scenes/ui/fares face.png"), "#2ecc71", ["Nader", "Roaya"]),
	"Roaya": Character.new(preload("res://scenes/ui/Roaya Face.png"), "#9b59b6", ["Nader", "Fares"]),
	"Gaser": Character.new(preload("res://scenes/ui/Gaser face new.png"), "#9b59b6", []),
}

# Dialogue Entry class
class DialogueEntry:
	var name: String
	var text: String
	
	func _init(character_name: String, dialogue_text: String):
		name = character_name
		text = dialogue_text


# Current conversation (array of DialogueEntry)
var conversation: Array[DialogueEntry] = []
var current_index: int = 0

# Reference to the TextureRect that shows the current speaker
@export var speaker_portrait: TextureRect
@export var listener1_portrait: TextureRect
@export var listener2_portrait: TextureRect
@export var dialogue_text: RichTextLabel
@export var character_name_label: RichTextLabel
@export var color_panel: Panel

# Font size
@export var main_text_font_size: int = 18
@export var char_name_font_size: int = 18
# Text speed (characters per second)
@export var text_speed: float = 20.0

# Hardcoded conversation
var is_typing: bool = false
var full_text: String = ""

func _ready():
	# Hide dialogue system on start
	hide_dialogue()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Only process clicks if dialogue is active
			if visible and conversation.size() > 0:
				if is_typing:
					# Show all text instantly
					show_full_text()
				else:
					# Go to next dialogue
					next_dialogue()

func start(new_conversation: Array[DialogueEntry]):
	conversation = new_conversation
	current_index = 0
	show_dialogue()
	display_current_dialogue()

func display_current_dialogue():
	if current_index >= conversation.size():
		end_conversation()
		return

	var entry = conversation[current_index]

	# Set the speaker's sprite and color
	if characters.has(entry.name):
		var character = characters[entry.name]
		speaker_portrait.texture = character.sprite

		# Update Panel background color
		if color_panel:
			var stylebox = color_panel.get_theme_stylebox("panel")
			if stylebox is StyleBoxFlat:
				stylebox.bg_color = Color(character.color)

		# Clear listener portraits first
		if listener1_portrait:
			listener1_portrait.texture = null
		if listener2_portrait:
			listener2_portrait.texture = null

		# Set listener portraits from the character's listeners
		if character.listeners.size() >= 1 and listener1_portrait and characters.has(character.listeners[0]):
			listener1_portrait.texture = characters[character.listeners[0]].sprite
		if character.listeners.size() >= 2 and listener2_portrait and characters.has(character.listeners[1]):
			listener2_portrait.texture = characters[character.listeners[1]].sprite

	# Display the character name
	character_name_label.text = "[color=black][font_size=" + str(char_name_font_size) + "]" + entry.name + "[/font_size][/color]"

	# Start typewriter effect for dialogue text
	full_text = "[color=black][font_size=" + str(main_text_font_size) + "]" + entry.text + "[/font_size][/color]"
	dialogue_text.text = ""
	start_typewriter(entry.text)

func start_typewriter(plain_text: String):
	is_typing = true
	var char_index = 0
	var time_per_char = 1.0 / text_speed

	while char_index < plain_text.length():
		if not is_typing:
			# Typing was interrupted, show full text
			break

		char_index += 1
		var displayed_text = plain_text.substr(0, char_index)
		dialogue_text.text = "[color=black][font_size=" + str(main_text_font_size) + "]" + displayed_text + "[/font_size][/color]"

		await get_tree().create_timer(time_per_char).timeout

	# Finished typing
	is_typing = false
	dialogue_text.text = full_text

func show_full_text():
	is_typing = false
	dialogue_text.text = full_text

func next_dialogue():
	current_index += 1
	display_current_dialogue()

func end_conversation():
	is_typing = false
	conversation.clear()
	current_index = 0
	# Clear the UI
	character_name_label.text = ""
	dialogue_text.text = ""
	hide_dialogue()

func show_dialogue():
	visible = true

func hide_dialogue():
	visible = false
