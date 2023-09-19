extends Node
class_name HealthComponent

signal health_depleted

export var health_points : int 

func update_health(amount : int ):
	health_points -= amount
	
	var is_depleted = check_if_depleted(amount)
	
	if is_depleted:
		emit_signal("health_depleted")
		

func check_if_depleted(change : int) -> bool:
	if (health_points - change) < 0:
		return true 
	return false

