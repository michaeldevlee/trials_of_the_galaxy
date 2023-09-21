extends KinematicBody2D
class_name Boss

onready var anim_player = $AnimationPlayer
onready var state_manager = $StateMachine
onready var health = $HealthComponent
onready var collision_shape = $CollisionShape2D
onready var invicibility_frames = $InvincibilityFrames
onready var DEBUG = $DEBUG

var velocity : Vector2 = Vector2.ZERO

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
	if !invicibility_frames.active:
		health.update_health(amount)
		invicibility_frames.init_invincibility_frames()
		DEBUG.set_health_text(str(health.health_points))

func init_death():
	queue_free()
