extends Node2D

const ORIGINAL_POSITION = Vector2(0, 0)
const ORIGINAL_NEXT_POSITION = Vector2(160+16, 8+16+60)

var next_position = Vector2(160+16, 8+16+20)
var all_rockets
var rocket_tween
var count : int = 0
var max_count : int = 1

onready var rockets_root = $Rockets
onready var timer = $Timer

signal attack_ended
signal rocket_hit_player

func _ready():
	connect_signals()
	init()


func init():
	reset_positions()
	var rockets = rockets_root.get_children()
	for rocket in rockets:
		rocket.position = next_position
		next_position += Vector2(0, (144-100)/4)
		
	randomize()
	rockets.shuffle()
	all_rockets = rockets
	timer.start()

func exit():
	emit_signal("rocket_hit_player")
	queue_free()

func connect_signals():
	timer.connect("timeout", self, "start_rocket_launch")
	
	for rocket in rockets_root.get_children():
		rocket.connect("player_hit", self, "exit")

func reset_positions():
	for rocket in rockets_root.get_children():
		rocket.position = ORIGINAL_POSITION
		next_position = ORIGINAL_NEXT_POSITION

func start_rocket_launch():
	if all_rockets:
		var rocket = all_rockets.pop_front()
		var tween = create_tween()
		rocket_tween = tween
		tween.tween_property(rocket, "position", rocket.position + Vector2(-16, 0), 0.2)
		tween.tween_callback(rocket.animation_player, "play", ["Shake"])
		tween.tween_interval(0.2)
		tween.tween_callback(rocket.animation_player, "stop")	
		tween.tween_property(rocket, "position", rocket.position + Vector2(-200, 0), 1)
		$BossRocket.play()
		if all_rockets.size() == 0:
			tween.connect("finished", self, "restart_rocket_launch")
			$BossRocket.stop()
			count += 1
			
func restart_rocket_launch():
	if count <= max_count:
		rocket_tween.stop()
		$BossRocket.stop()
		init()
	else:
		$BossRocket.stop()
		emit_signal("attack_ended")

