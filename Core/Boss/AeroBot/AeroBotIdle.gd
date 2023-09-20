extends BossState
class_name Idle_BossState

func enter(_msg := {}):
	var tween = create_tween()
	boss.velocity = Vector2.ZERO
	tween.tween_property(boss, "global_position", boss.global_position + Vector2(0, -160), 1)

func update(delta) -> void:
	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("Pound")

func reset_position() -> void:
	pass
	
