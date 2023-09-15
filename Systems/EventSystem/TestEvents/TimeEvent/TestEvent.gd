extends Event

onready var timer = get_node("Timer")

func _ready():
	timer.connect("timeout", self, "finish")

func init():
	timer.start()
