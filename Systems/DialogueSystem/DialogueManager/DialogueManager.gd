extends Node2D

onready var base_dialogue_object = preload("res://Systems/DialogueSystem/Dialogue/Dialogue.tscn")

var dialogue_dictionary

signal dialogue_state_changed(state)

func load_dialogue(file_path):
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, File.READ)
	var content = parse_json(file.get_as_text())
	file.close()
	return content

func _ready():
	var char_name = "Bob"
	var file_path = "res://Systems/DialogueSystem/DialogueText/DialogueText.json"
	dialogue_dictionary = load_dialogue(file_path)
	
func start_dialogue(dialogue : Dialogue = null, char_name : String = "null", start_branch : String = "1A"):
	if dialogue:
		dialogue.connect("dialogue_finished", self, "notifiy_dialogue_state_changed", [dialogue])
		
		if dialogue_dictionary and dialogue_dictionary.has(char_name.to_upper()):
			dialogue.init(char_name.to_upper(), dialogue_dictionary)
		elif dialogue_dictionary:
			dialogue.init("ERROR", dialogue_dictionary)		
		else:
			print("There is no JSON dictionary to reference")

func notifiy_dialogue_state_changed(dialogue_object : Dialogue):
	var updated_branch = dialogue_object.current_branch.substr(0,1)
	
	#add parameters that other entities are interested in
	var state = {}
	print('you stopped dialogue on this branch: ' + updated_branch)
	
	#you have access to dialogue requestor if you need to update directly
	
	#notifies that dialogue has ended, subscribers can access state object properties
	emit_signal("dialogue_state_changed", state)
	dialogue_object.queue_free()
	cleanup()
	
func cleanup():
	pass
