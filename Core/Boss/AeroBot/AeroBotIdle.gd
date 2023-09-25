extends BossState
class_name Idle_BossState

onready var timer = get_node("Timer")

export var wait_time : int = 2

var ORIGINAL_POSITION : Vector2 = Vector2(160-24, 144/2)

func _ready():
	timer.connect("timeout", self, "init_transition")

func enter(_msg := {}):
	set_process(true)
	reset_position()
	boss.anim_player.play("Idle")

func exit():
	set_process(false)	

func init_transition():
	state_machine.transition_to("FromIdle")

func reset_position() -> void:
	boss.velocity = Vector2.ZERO
	timer.wait_time = wait_time
	
	var tween = create_tween()
	tween.tween_property(boss, "position",ORIGINAL_POSITION, 1)
	tween.tween_callback(timer, "start")
	
