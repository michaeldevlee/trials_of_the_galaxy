extends Node
class_name InvincibilityComp

onready var timer = $Timer

export var entity_to_apply_frames : NodePath

var active : bool = false
var entity

signal invincibility_finished

func _ready():
	timer.connect("timeout", self, "end_invincibility_frames")
	if entity_to_apply_frames:
		var tmp = get_node(entity_to_apply_frames)
		
		if "visible" in tmp:
			entity = tmp

func init_invincibility_frames():
	active = true
	timer.start()
	var tween = create_tween().set_loops(5)
	tween.tween_property(entity, "visible", false, 0.05).from_current()
	
	
func end_invincibility_frames():
	active = false
	emit_signal("invincibility_finished")
	entity.visible = true
	
