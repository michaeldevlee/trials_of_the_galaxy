extends BossState
class_name Attack_1TestBoss

onready var pound_timer = get_node("Timer")

export var tween_path : NodePath
var tween : Tween
var count : int = 0
var max_count : int = 3

func _ready():
	pound_timer.connect("timeout", self, "repeat_pound")
	connect("finished", self, "return_to_idle")
	if tween_path:
		tween = get_node(tween_path)

func enter(_msg := {}):
	var new_location = get_tree().get_nodes_in_group("Player")[0].global_position.x
	boss.velocity = Vector2.ZERO
	boss.anim_player.play("Attack_1")
	tween.interpolate_property(boss, "global_position", boss.global_position, Vector2(new_location, 0),  1, Tween.TRANS_LINEAR)
	tween.connect("tween_completed", self, "pound")	
	tween.start()

func pound(object : Object, key : NodePath):
	if key == ":global_position":
		boss.pounding = true
		boss.ray_cast.enabled = true

func repeat_pound():
	var new_location = get_tree().get_nodes_in_group("Player")[0].global_position.x
	tween.interpolate_property(boss, "global_position", boss.global_position, Vector2(new_location, 0),  1, Tween.TRANS_LINEAR)
	tween.start()
	
	
func return_to_idle():
	state_machine.transition_to("Idle")

func _physics_process(delta):
	if boss.ray_cast.is_colliding():
		print("is colliding")
		repeat_pound()
		boss.ray_cast.enabled = false
