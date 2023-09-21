extends BossState
class_name AeroBotBarrage

func enter(msg:={}):
	var tween = create_tween()
	tween.tween_property(boss, "global_position:x", boss.global_position.x + 160, 1)
	

func exit():
	pass


