extends CharacterBody2D

@export var speed = 200

func get_direction():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction

func _physics_process(delta):
	get_direction()
	move_and_slide()
