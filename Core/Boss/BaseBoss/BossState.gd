extends State
class_name BossState

signal finished

var boss : Boss

func _ready() -> void:
	yield(owner, "ready")
	boss = owner as Boss
	assert(boss != null)
