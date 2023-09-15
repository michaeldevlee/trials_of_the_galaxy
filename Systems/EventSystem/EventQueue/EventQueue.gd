extends Node2D
class_name EventQueue

var index = 0

func _ready():
	start_event()

func start_event():
	if index < get_children().size():
		var curr_event = get_children()[index]
		print(curr_event)
		curr_event.connect("event_finished", self, "start_event")
		curr_event.init()
		index += 1
	else:
		print('last event ended')

func add_event(event):
	var event_instance = event.instance()
	add_child(event_instance)

