extends BossState
class_name AeroBotBarrage

var barrage_attack_ref = preload("res://Core/Boss/AeroBot/BarrageFullScreenAttack.tscn")

func enter(msg:={}):
	var tween = create_tween()
	tween.tween_property(boss, "global_position:x", boss.global_position.x + 160, 1)
	tween.tween_callback(self, "init_attack")
	

func exit():
	pass

func init_attack():
	var barrage_attack = barrage_attack_ref.instance()
	get_tree().root.get_child(0).add_child(barrage_attack)
	barrage_attack.connect("attack_ended", state_machine, "transition_to", ["Idle"])
	barrage_attack.connect("rocket_hit_player", state_machine, "transition_to", ["Idle"])


