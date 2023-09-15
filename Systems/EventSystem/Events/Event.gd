extends Node2D
class_name Event

signal event_finished

func _ready():
	pass
		
func init():
	print('event started')

func finish():
	emit_signal("event_finished")
	print('event ended')

func cleanup():
	queue_free()
