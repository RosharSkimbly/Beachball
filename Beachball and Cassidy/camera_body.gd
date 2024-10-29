extends CharacterBody2D

@export var speed = 200
var cassidyposition = 1336


func get_direction():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction


func _physics_process(delta):
	if Input.is_action_pressed("run"):
		speed = 400
	else:
		speed = 200
	get_direction()
	if cassidyposition - 7 <= position[0] and cassidyposition + 7 >= position[0]:
		move_and_slide()


func _on_world_checkfinal(x) -> void:
	cassidyposition = x
