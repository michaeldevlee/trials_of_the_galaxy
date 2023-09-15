extends CanvasLayer
class_name Dialogue

onready var tween = get_node("Tween")
onready var text = get_node("MarginContainer/VBoxContainer/HBoxContainer2/ReplaceMe/MarginContainer/VBoxContainer/dialogue_display_text")
onready var char_name = get_node("MarginContainer/VBoxContainer/HBoxContainer2/ReplaceMe/MarginContainer/VBoxContainer/character_name_text")
onready var options_root = get_node("MarginContainer/VBoxContainer/HBoxContainer2/ReplaceMe/MarginContainer/VBoxContainer/Choices/Options")
onready var dialogue_marker = get_node("MarginContainer/VBoxContainer/HBoxContainer2/ReplaceMe/dialogue_marker")

var option = preload("res://Systems/DialogueSystem/Dialogue/Option.tscn")

signal dialogue_started
signal dialogue_finished

var messages 
var char_display_name
var current_branch = "1A"
var current_dialogue_object
var curr_text
var text_scroll_speed = 1
var index = 0
var choice_mode : bool = false
var important_text_color = "red"

func _ready():
	visible = false
	tween.connect("tween_completed", self, "show_marker")
	tween.connect("tween_completed", self, "show_options")


func init(dialogue_char : String, dialogue_text):
	visible = true
	current_dialogue_object = dialogue_text
	emit_signal("dialogue_started")
	open_dialogue()
	load_messages(dialogue_char, dialogue_text)
	display_message()


func load_messages(dialogue_char, dialogue_text):
	char_display_name = dialogue_char
	messages = dialogue_text[char_display_name][index][current_branch]

func close_dialogue():
	visible = false

func open_dialogue():
	visible = true

func display_message():
	dialogue_marker.visible = false
	
	if tween.is_active():
		tween.playback_speed = 7
		return
	else:
		tween.playback_speed = 1
	
	if messages and char_display_name:
		if index > messages.size()-1:
			emit_signal("dialogue_finished")
			print('dialogue finished')
			return
			
		curr_text = messages[index]
		
		var text_to_be_displayed = apply_styles(curr_text)
		
		self.char_name.set_text(char_display_name)
		text.percent_visible = 0
		text.set_bbcode(text_to_be_displayed)
		tween.interpolate_property(text, "percent_visible", 0, 1, text_scroll_speed ,Tween.TRANS_LINEAR)		
		tween.start()
		
		index += 1

func apply_styles(text_object : Dictionary) -> String:
	var unformatted_text : String = text_object.text
	var new_text = unformatted_text

	if text_object.has("underlined"):
		for text in text_object["underlined"]:
			new_text = new_text.replace(text, "[u]" + text + "[/u]")
			
		
	if text_object.has("bolded"):
		for text in text_object["bolded"]:
			new_text = new_text.replace(text, "[b]" + text + "[/b]")
			
	if text_object.has("important"):
		for text in text_object["important"]:
			new_text = new_text.replace(text, "[color=" +important_text_color+ "]" + text + "[/color]")
	
	return new_text



func has_choices(text_object : Dictionary) -> bool:
	if text_object.has("pivot"):
		return true
	else:
		return false

func load_choices(options):
	choice_mode = true
	if options_root.get_child_count() == 0:
		for option in options:
			var option_text = options[option]
			var option_button_instance = self.option.instance()
			options_root.add_child(option_button_instance)
			option_button_instance.set_button_name(option_text)
			option_button_instance.connect("button_up", self, "update_branch", [option_button_instance.button_name])		
		
func remove_choices():
	choice_mode = false
	for option in options_root.get_children():
		option.queue_free()

func update_branch(new_branch):
	current_branch = new_branch
	reset()
	load_messages(char_display_name, current_dialogue_object)
	display_message()
	remove_choices()

func show_options(tween : Tween, key : NodePath):
	if key == ":percent_visible":
		if has_choices(curr_text):
			load_choices(curr_text["pivot"])

func show_marker(tween : Tween, key : NodePath):
	if key == ":percent_visible":
		dialogue_marker.visible = true

func reset():
	index = 0

func clear_messages():
	messages = []

func _process(delta):
	if Input.is_action_just_pressed("interact") and visible:
		if !choice_mode:
			display_message()
