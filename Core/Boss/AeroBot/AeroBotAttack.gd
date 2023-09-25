extends BossState
class_name AeroBotPound

onready var pound_timer = get_node("Timer")

var count : int = 0
var max_count : int = 3
var scan_tween
var pound_tween
var player_position 


func _ready():
	pound_timer.connect("timeout", self, "init_scan")
	connect("finished", self, "return_to_idle")
	set_process(false)
	
func enter(_msg := {}):
	set_process(true)
	boss.velocity = Vector2.ZERO
	boss.anim_player.play("Attack_1")
	init_scan()

func move(direction : Vector2):
	boss.velocity.move_toward(direction, 1)

func init_scan():
	if count >= max_count:
		state_machine.transition_to("Idle")
		return
	var tween = create_tween()
	tween.tween_property(boss, "global_position", Vector2(boss.global_position.x, 24), 0.5)
	tween.tween_property(boss.ray_cast, "enabled" , true, 0)
	tween.tween_callback(self, "move_towards_player_x_pos")

func set_direction() -> int:
	if boss.global_position.x - player_position.x > 0:
		return 24
	else:
		return 136

func move_towards_player_x_pos():
	var tween = create_tween()
	tween.tween_property(boss, "global_position:x", set_direction(), 0.5)
	scan_tween = tween

func update_player_position():
	if get_tree().get_nodes_in_group("Player"):
		player_position = get_tree().get_nodes_in_group("Player")[0].global_position

func detect_player_collision():
	if boss.get_last_slide_collision():
		var collider = boss.get_last_slide_collision().collider
		if collider is Player:
			collider.take_damage(10)
			state_machine.transition_to("Idle")

func pound(y_pos : int):
	var tween = create_tween()
	tween.tween_property(boss, "global_position:y", y_pos, 0.5)
	tween.tween_callback(pound_timer, "start")
	$PoundSFX.play()
	pound_tween = tween
	count += 1

func scan_for_player():
	var ray_cast : RayCast2D = boss.ray_cast
	
	if ray_cast.is_colliding():
		var player = ray_cast.get_collider()
		var y_pos = 144-24-16
		ray_cast.enabled = false
		scan_tween.stop()
		pound(y_pos)
		

func exit():
	set_process(false)	
	pound_timer.stop()
	if pound_tween:
		pound_tween.stop()
	scan_tween.stop()
	boss.ray_cast.enabled = false
	count = 0

func _process(delta):
	scan_for_player()
	update_player_position()
	detect_player_collision()
