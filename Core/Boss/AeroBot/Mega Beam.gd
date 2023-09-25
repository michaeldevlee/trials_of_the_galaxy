extends BossState
class_name AeroBotMegaBeam

var aim_active : bool = false
var beam_active : bool = false
var beam_direction
var count : int = 0
var max_count : int = 3

var active_tween

onready var beam_active_timer = get_node("Timer")

func _ready():
	beam_active_timer.connect("timeout", self, "shoot_beam")

func enter(_msg := {}):
	set_physics_process(true)
	boss.anim_player.play("ChargeBeam")
	init()

func exit():	
	stop_beam()
	beam_active_timer.stop()
	if active_tween:
		active_tween.stop()
	count = 0
	boss.beam_area.disconnect("body_entered", self, "player_hit")
	set_physics_process(false)
		
	

func init():
	var tween = create_tween()
	active_tween = tween
	tween.tween_property(boss, "position", Vector2(80, 24), 0.5)
	tween.tween_interval(0.2)
	tween.tween_property(self, "aim_active", true, 0.1)
	tween.tween_callback(boss.anim_player, "play", ["ChargeBeam"])
	tween.tween_property(self, "aim_active", false, 2)
	tween.tween_callback(self, "move_beam_towards_player")

func shoot_beam():
	stop_beam()
	
	if count <= max_count:
		var tween = create_tween()
		active_tween = tween
		tween.tween_property(self, "aim_active", true, 0.1)
		tween.tween_callback(boss.anim_player, "play", ["ChargeBeam"])
		tween.tween_property(self, "aim_active", false, 2)
		tween.tween_callback(self, "move_beam_towards_player")
		count += 1
	else:
		state_machine.transition_to("Idle")

func aim_at_player():
	if aim_active:
		var player_position = get_tree().get_nodes_in_group("Player")[0].position
			
		var ray_cast : RayCast2D = boss.mega_beam_cast
		ray_cast.cast_to = player_position - boss.position

func move_beam_towards_player():
	boss.beam_area.connect("body_entered", self, "player_hit")
	boss.beam_anim_player.play("Shake")
	var player_position = get_tree().get_nodes_in_group("Player")[0].position
	var ray_cast : RayCast2D = boss.mega_beam_cast
	var beam : Sprite = boss.beam
	
	var beam_shoot_angle = ray_cast.cast_to.angle() * 180/PI - 180
	var beam_target_angle = set_target_angle()
	
	beam.visible = true
	$MegaBeamSFX.play()
	beam.rotation_degrees = beam_shoot_angle
	beam_active = true
	set_target_angle()
	beam_active_timer.start()
	

func set_target_angle():
	var player_position = get_tree().get_nodes_in_group("Player")[0].position	
	if player_position.x > 80:
		beam_direction = -1
	else:
		beam_direction = 1
	
func rotate_beam(delta, direction):
	if beam_active:
		beam_direction = direction	
		boss.beam.rotation_degrees += 35 * delta * direction

func stop_beam():
	beam_active = false
	boss.beam.visible = false

func player_hit(body):
	body.take_damage(10)
	stop_beam()
	beam_active_timer.stop()
	count = 0
	if active_tween:
		active_tween.stop()
	state_machine.transition_to("Idle")

func _physics_process(delta):
	aim_at_player()
	rotate_beam(delta, beam_direction)

