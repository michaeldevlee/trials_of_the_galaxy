extends BossState
class_name AerobotFromIdle

var attack_states =["Pound", "Barrage", "Mega Beam"]
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func enter(_msg:={}):
	set_process(true)
	var tween = create_tween()
	var rand = generate_rand_index()
	
	tween.tween_callback(boss.anim_player, "play",["FromIdleTrans"])
	tween.tween_interval(1)
	tween.tween_callback(boss.anim_player, "stop")
	tween.tween_callback(state_machine, "transition_to", [attack_states[rand]])

func generate_rand_index() -> bool:
	return rng.randi_range(0, attack_states.size()-1)

func exit():
	set_process(false)
	
