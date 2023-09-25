extends CanvasLayer

onready var button = $Control/TextureRect/Button

func _on_Button_button_up():
	SceneTransitionManager.start_event_queue()
	button.disabled = true
	$ClickSFX.play()
	var tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(get_tree(), "change_scene", ["res://main.tscn"])

