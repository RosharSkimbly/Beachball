extends Node2D
signal ChangeScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	ChangeScene.emit() 
