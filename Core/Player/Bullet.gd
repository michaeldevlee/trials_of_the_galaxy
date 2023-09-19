extends KinematicBody2D
class_name Bullet

onready var timer = get_node("Timer")

export (String, "NORTH", "SOUTH", "EAST", "WEST") var direction = "EAST" 
export var bullet_speed : int = 10

var velocity : Vector2 = Vector2.ZERO 
var speed_multiplier : int = 500

func _ready():
	timer.connect("timeout", self, "clean_up")

func process_movement(delta):
	match direction:
		"NORTH":
			velocity.y = -bullet_speed * delta * speed_multiplier
		"SOUTH":
			velocity.y = bullet_speed * delta * speed_multiplier			
		"EAST":
			velocity.x = bullet_speed * delta * speed_multiplier
		"WEST":
			velocity.x = -bullet_speed * delta * speed_multiplier			
func set_travel_direction(player_direction):
	self.direction = player_direction

func clean_up():
	queue_free()

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	process_movement(delta)
