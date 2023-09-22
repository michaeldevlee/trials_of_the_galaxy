extends CanvasLayer

onready var start_time = OS.get_ticks_msec()
onready var timer_display = get_node("Control/Layer2/Timer/Label")


func update_timer_display():
	var time = OS.get_ticks_msec()/1000 - start_time/1000
	var seconds = time % 60
	var minutes = time / 60
	
	
	timer_display.set_text(str("%02d" % minutes) + " : " + str("%02d" % seconds))

func _process(delta):
	update_timer_display()

