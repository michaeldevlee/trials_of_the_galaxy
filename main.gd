extends Node2D

onready var anim_player = $Credits/AnimationPlayer
onready var animation_player_2 = $Credits/AnimationPlayer2
onready var button = $Credits/ColorRect2/Button



func _ready():
	EventBus.connect("boss_died", self, "start_credits")
	EventBus.connect("player_died", self, "start_credits")

func start_credits():
	$DeathSFX.play()
	var player = get_tree().get_nodes_in_group("Player")[0].set_physics_process(false)
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(anim_player, "play", ["fade"])
	tween.tween_interval(2)
	tween.tween_callback(animation_player_2, "play", ["credit_fade_in"])
	


func _on_Button_button_up():
	SceneTransitionManager.start_event_queue()
	button.disabled = true
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(get_tree(), "change_scene", ["res://UI/StartMenu.tscn"])
