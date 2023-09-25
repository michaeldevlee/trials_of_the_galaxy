extends KinematicBody2D
class_name Boss

onready var anim_player = $AnimationPlayer
onready var state_manager = $StateMachine
onready var health = $HealthComponent
onready var collision_shape = $CollisionShape2D
onready var invicibility_frames = $InvincibilityFrames

var velocity : Vector2 = Vector2.ZERO

func _ready():
	health.connect("health_depleted", self, "init_death")
	EventBus.connect("player_died", self, "clean_up")

func handle_collisions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		var body = collision.collider

		if body is Bullet:
			process_hit(10)
			body.queue_free()
			GameState.score += 50
			GameState.start_player_notification("+ 50")
			EventBus.emit_signal("boss_hurt")
			EventBus.emit_signal("health_changed", self , health.health_points)
		
		if body is TileMap:
			pass

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	handle_collisions()

	
func process_hit(amount : int):
	if !invicibility_frames.active:
		$HurtSFX.play()
		health.update_health(amount)
		invicibility_frames.init_invincibility_frames()

func init_death():
	$DeathSFX.play()
	EventBus.emit_signal("boss_died")
	queue_free()

func clean_up():
	set_physics_process(false)
	queue_free()
 
