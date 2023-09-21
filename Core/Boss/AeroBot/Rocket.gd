extends KinematicBody2D
class_name Rocket

onready var animation_player = $AnimationPlayer

signal player_hit

var velocity : Vector2 = Vector2.ZERO

func handle_collisions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var body = collision.collider

		if body is Player:
			body.take_damage(10)
		
		emit_signal("player_hit")
		return

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	handle_collisions()
