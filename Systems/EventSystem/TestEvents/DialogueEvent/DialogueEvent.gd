extends Event
class_name DialogueEvent

export var dialogue_object : PackedScene
var dialogue
export var char_name = "Mike"

func init():
	if dialogue_object:
		dialogue  = DialogueManager.base_dialogue_object.instance()
		add_child(dialogue)
		dialogue.connect("dialogue_finished", self, "finish")
		DialogueManager.start_dialogue(dialogue, char_name)

func set_char_name(name : String):
	char_name = name

func set_dialogue_object(packed_scene : PackedScene):
	dialogue_object = packed_scene
