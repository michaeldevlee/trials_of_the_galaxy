extends CanvasLayer

onready var start_time = OS.get_ticks_msec()
onready var timer_display = get_node("Control/Layer2/Timer/Label")
onready var label = $Control/Layer1/Score/Label
onready var boss_hp = $Control/Layer3/VBoxContainer4/VBoxContainer/BossHP
onready var player_hp = $Control/Layer3/VBoxContainer3/VBoxContainer/PlayerHP

func _ready():
	EventBus.connect("boss_hurt", self, "update_score")
	EventBus.connect("health_changed", self, "update_hp")
	update_score()

func update_timer_display():
	var time = OS.get_ticks_msec()/1000 - start_time/1000
	var seconds = time % 60
	var minutes = time / 60
	
	
	timer_display.set_text(str("%02d" % minutes) + " : " + str("%02d" % seconds))

func update_score():
	label.set_text(str(GameState.score))

func update_hp(entity, new_value : int):
	if entity is Player:
		player_hp.set_text(str(new_value))
	if entity is Boss:
		boss_hp.set_text(str(new_value))

func _process(delta):
	update_timer_display()

