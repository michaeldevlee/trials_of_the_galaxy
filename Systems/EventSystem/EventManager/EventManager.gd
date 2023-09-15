extends Node2D


var event_ref = preload("res://Systems/EventSystem/Events/Event.tscn")
var event_queue_ref = preload("res://Systems/EventSystem/EventQueue/EventQueue.tscn")

func create_event(event_queue : EventQueue) -> Event:
	if event_queue:
		var event = event_ref.instance()
		return event
	else:
		print('no event queue found')
		return null

func create_event_queue() -> EventQueue:
	var event_queue = event_queue_ref.instance()
	add_child(event_queue)
	return event_queue

func stop_event_queue():
	pass
