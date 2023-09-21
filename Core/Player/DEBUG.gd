extends Node2D

onready var health_display = get_node("Label")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_health_text(text : String):
	health_display.set_text(text)

