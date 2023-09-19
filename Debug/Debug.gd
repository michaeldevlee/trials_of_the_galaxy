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
	update_all_labels()
	visible = false
	set_process(false)

func update_all_labels():
	if player:
		player_state.set_text("Facing Direction: " + player.shooting_direction)
		locked_state.set_text("Locked: " + str(player.is_lock_direction))
		dashing_state.set_text("Dashing: " + str(player.is_dashing))

func _process(delta):
	update_all_labels()
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		visible = !visible
		set_process(true)
