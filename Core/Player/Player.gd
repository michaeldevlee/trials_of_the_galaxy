extends KinematicBody2D
class_name Player

export var movement_speed : int = 200
export var jump_speed : int = 5
export var speed_multiplier : int = 50

var velocity = Vector2()
var gravity = 9.8


func apply_gravity(delta):
	velocity.y += gravity * delta * 100
	
func get_user_movement_input(delta):
	velocity.x = 0
	print(is_on_floor())
	if Input.is_action_pressed("left"):
		velocity.x = -movement_speed * delta * speed_multiplier
	if Input.is_action_pressed("right"):
		velocity.x = movement_speed * delta * speed_multiplier
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print(is_on_floor())
		velocity.y -= jump_speed * 50

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	apply_gravity(delta)
	get_user_movement_input(delta)
