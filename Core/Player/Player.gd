extends KinematicBody2D
class_name Player

const MOVEMENT_SPEED_ORIGINAL = 60

onready var cd_timer = get_node("Shoot_CD_Timer")
onready var cd_dash_timer = get_node("Dash_CD_Timer")
onready var dash_timer = get_node("DashTimer")
onready var invincibility_timer = get_node("InvincibilityTimer")
onready var anim_player = get_node("AnimationPlayer")
onready var anim_player2 = get_node("AnimationPlayer2")
onready var sprite = get_node("Sprite")
onready var health_comp = get_node("HealthComponent")
onready var DEBUG = get_node("DEBUG")

export var movement_speed : int = 60
export var jump_speed : int = 7
export var speed_multiplier : int = 50
export (String, "NORTH", "SOUTH", "EAST", "WEST") var shooting_direction = "EAST" 

var velocity = Vector2()
var gravity = 9.8
var bullet_ref = preload("res://Core/Player/Bullet.tscn")
var is_lock_direction : bool = false
var shoot_cool_down : float  = 0.5
var can_shoot : bool = true
var is_dashing : bool = false
var can_dash : bool = true
var is_invincible : bool = false
var invincibility_time : int = 2

func _ready():
	health_comp.connect("health_depleted", self, "handle_death")
	cd_timer.connect("timeout", self, "reset_shoot")
	cd_dash_timer.connect("timeout", self, "reset_dash")
	dash_timer.connect("timeout", self, "end_dash")
	invincibility_timer.connect("timeout", self, "end_invincibility")

func apply_gravity(delta):
	if !is_dashing:
		velocity.y += gravity * delta * 100
	
func get_user_input(delta):
	velocity.x = 0
	if Input.is_action_pressed("left"):
		update_shooting_direction("WEST")
		velocity.x = -movement_speed * delta * speed_multiplier
	if Input.is_action_pressed("right"):
		update_shooting_direction("EAST")
		velocity.x = movement_speed * delta * speed_multiplier
	if Input.is_action_pressed("up"):
		update_shooting_direction("NORTH")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_speed * 50
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	
	if Input.is_action_just_pressed("lock_facing_direction"):
		is_lock_direction = !is_lock_direction
	
	if Input.is_action_just_pressed("dash"):
		if can_dash and !is_dashing and abs(velocity.x) > 0:
			dash()
	
	if Input.is_action_just_pressed("ui_down"):
		shoot_cool_down -= 0.1

func apply_anims():
	if velocity.x == 0 and is_on_floor():
		anim_player.play("Idle")
	elif abs(velocity.y) > 1 and !is_on_floor():
		anim_player.play("Jump")
	
	if velocity.x > 0:
		sprite.flip_h = false
	if velocity.x < 0:
		sprite.flip_h = true

func take_damage(amount : int):
	if !is_invincible:
		anim_player2.play("Hurt")
		invincibility_timer.start()
		is_invincible = true
		health_comp.update_health(amount)
		DEBUG.set_health_text(str(health_comp.health_points))

func end_invincibility():
	is_invincible = false
	anim_player2.stop()
	sprite.visible = true

func update_shooting_direction(direction):
	if is_lock_direction == true:
		return
	
	shooting_direction = direction

func start_cool_down():
	cd_timer.wait_time = shoot_cool_down
	cd_timer.start()
	can_shoot = false

func reset_dash():
	can_dash = true

func dash():
	is_dashing = true
	can_dash = false
	dash_timer.wait_time = 0.2
	dash_timer.start()
	movement_speed *= 4
	velocity.y = 0
	
func end_dash():
	movement_speed = MOVEMENT_SPEED_ORIGINAL
	is_dashing = false
	cd_dash_timer.start()
	
func change_movement_speed(speed):
	movement_speed = speed

func reset_shoot():
	can_shoot = true

func shoot():
	start_cool_down()
	var bullet = bullet_ref.instance()
	bullet.direction = shooting_direction
	owner.add_child(bullet)
	bullet.transform = self.global_transform

func handle_death():
	queue_free()

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	apply_gravity(delta)
	get_user_input(delta)
	apply_anims()
