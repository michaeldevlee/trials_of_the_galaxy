extends BossState


func _ready():
	EventBus.connect("boss_started", self, "start_boss")

func start_boss():
	state_machine.transition_to("Idle")
	
