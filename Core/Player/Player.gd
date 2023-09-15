extends KinematicBody2D
class_name Player

export var movement_speed : int = 10
export var jump_speed : int = 5

var velocity = Vector2()
var gravity = 9.8


func apply_gravity(delta):
	velocity.y += gravity * delta * 100
	
func get_user_movement_input():
	velocity.x = 0
	if Input.is_action_pressed("left"):
		velocity.x = -movement_speed * 50
	if Input.is_action_pressed("right"):
		velocity.x = movement_speed * 50
	if Input.is_action_just_pressed("jump"):
		velocity.y += jump_speed * 100

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	apply_gravity(delta)
	get_user_movement_input()
