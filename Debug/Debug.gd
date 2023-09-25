extends CanvasLayer

onready var player_state = $VBoxContainer/PlayerState
onready var locked_state = $VBoxContainer/Locked
onready var dashing_state = $VBoxContainer/Dashing

export var player_path : NodePath
var player

func init():
	if player_path:
		player = get_node(player_path)

func _ready():
	init()
	visible = false
	set_process(false)
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		visible = !visible
		set_process(true)
