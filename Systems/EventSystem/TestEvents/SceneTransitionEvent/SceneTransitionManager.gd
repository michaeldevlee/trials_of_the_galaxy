extends CanvasLayer

onready var anim_player = get_node("AnimationPlayer")

var event_queue = preload("res://Systems/EventSystem/TestEvents/SceneTransitionEvent/SceneEventQueue.tscn")

func start_event_queue():
	var eq = event_queue.instance()
	add_child(eq)
	eq.start_event()
