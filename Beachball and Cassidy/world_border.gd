extends Node2D

signal change_scene


func _on_area_2d_body_entered(body: Node2D) -> void:
	"""Emits the signal to change the room in the main scene's script when the
	player hits the collision shape at the border, then updates the global
	variable to show that this is the second time the scene has been 
	instantiated this run of the game.
	
	Args:
		body: Node2D: A variable that represents Node2D nodes that collide
		with the Area2D
	"""
	if body is RigidBody2D:
		pass
	else:
		GlobalNums.first_time = false
		change_scene.emit()


func _ready():
	"""When instantiated, if this not the first time, the player model is 
	moved to the left side of the map instead of near the crashed pod
	"""
	if GlobalNums.first_time == false:
		$Cassidy.position[0] = 10
		$Cassidy.position[1] = 820
