extends TextureButton

onready var button_text = get_node("Button/Label")

var button_name

func _ready():
	button_name = button_text.text

func set_button_name (name):
	button_name = name
	button_text.set_text(name)
