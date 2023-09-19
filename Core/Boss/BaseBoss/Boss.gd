extends KinematicBody2D
class_name Boss

onready var anim_player = $AnimationPlayer
onready var state_manager = $StateMachine
onready var health = $HealthComponent

var velocity = Vector2.ZERO

func _ready():
	health.connect("health_depleted", self, "init_death")

func handle_collisions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var body = collision.collider

		if body is Bullet:
			process_hit(10)
			body.queue_free()
		
		if body is TileMap:
			print("hit a collision")


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	handle_collisions()

	
func process_hit(amount : int):
	health.update_health(amount)

func init_death():
	queue_free()
