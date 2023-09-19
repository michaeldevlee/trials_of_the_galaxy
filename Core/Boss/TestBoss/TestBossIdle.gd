extends BossState
class_name Idle_BossState

func enter(_msg := {}):
	boss.velocity = Vector2.ZERO

func update(delta) -> void:
	if Input.is_action_just_pressed("ui_down"):
		state_machine.transition_to("Attack_1")
