extends Event


func init():
	var tween = create_tween()
	tween.connect("finished", self, "end_event")
	tween.tween_callback(SceneTransitionManager.anim_player, "play_backwards", ["Fade"])
	tween.tween_interval(2)
	tween.tween_callback(SceneTransitionManager.anim_player, "play", ["Fade"])
	tween.tween_interval(1)
	

func end_event():
	finish()
