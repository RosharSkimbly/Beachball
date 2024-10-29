extends Node2D

signal ChangeScene
signal checkfinal

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		pass
	else:
		GlobalNums.firsttime = false
		ChangeScene.emit() 

func _ready():
	if GlobalNums.firsttime == false:
		$Cassidy.position[0] = 10
		$Cassidy.position[1] = 820
