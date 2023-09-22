extends CanvasLayer

onready var anim_player = $AnimationPlayer

func _ready():
	EventBus.connect("started_game", self, "start_tutorial")
	

func start_tutorial():
	anim_player.play("ControlDisplay")

func start_boss():
	EventBus.emit_signal("boss_started")
	

