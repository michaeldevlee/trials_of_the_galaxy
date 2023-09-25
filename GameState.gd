extends Node

var score = 0
var notification_ref = preload("res://UI/Notification.tscn")

func start_player_notification(message):
	var notification = notification_ref.instance() 
	var player_position = get_tree().get_nodes_in_group("Player")[0].position
	var main = get_tree().get_nodes_in_group("main")[0]
	main.add_child(notification)
	notification.rect_position = player_position
	notification.start_notification(message)
	
	
