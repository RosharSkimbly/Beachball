extends CharacterBody2D

@export var speed = 200
var animation_direction = 'Down'

func get_direction(animation_direction):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	if direction == Vector2(1, 0):
		animation_direction = "Right"
	elif direction == Vector2(-1, 0):
		animation_direction = "Left"
	elif direction == Vector2(0, -1):
		animation_direction = "Up"
	elif direction == Vector2(0, 1):
		animation_direction = "Down"
	
	
	var direction_array = [direction, animation_direction]
	return direction_array
	
	
func walk_cycle(direction):
	if get_direction(animation_direction)[0] == Vector2(1, 0):
		$AnimatedSprite2D.play("Walk Right")
	elif get_direction(animation_direction)[0] == Vector2(-1,0):
		$AnimatedSprite2D.play("Walk Left")
	elif get_direction(animation_direction)[0] == Vector2(0, -1):
		$AnimatedSprite2D.play("Walk Up")
	elif get_direction(animation_direction)[0] == Vector2(0, 1):
		$AnimatedSprite2D.play("Walk Down")
	elif get_direction(animation_direction)[0] == Vector2(0, 0):
		$AnimatedSprite2D.play("Idle " + direction)
		

func _physics_process(delta):
	if Input.is_action_pressed("run"):
		speed = 400
	else: 
		speed = 200
	animation_direction = get_direction(animation_direction)[1]
	get_direction(animation_direction)
	move_and_slide()
	walk_cycle(animation_direction)
