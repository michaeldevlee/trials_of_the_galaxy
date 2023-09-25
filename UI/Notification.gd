extends Control

onready var animation_player = $AnimationPlayer
onready var notification = $Notification

func start_notification(message : String):
	animation_player.connect("animation_finished", self, "clean_up")
	animation_player.play("Appear")
	notification.set_text(message)

func clean_up(object):
	queue_free()
