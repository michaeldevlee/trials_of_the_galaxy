extends Boss
class_name TestBoss

onready var ray_cast = get_node("RayCast2D")

var pounding : bool = false

func pound():
	velocity.y += 5

func _physics_process(delta):
	if pounding:
		pound()
	
	if ray_cast.is_colliding():
		pounding = false

