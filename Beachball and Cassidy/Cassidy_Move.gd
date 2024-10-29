extends CharacterBody2D

@export var speed = 200
var animation_direction = "Down"
@export var not_frozen = true


func get_direction(animation_direction):
	#Assigns vectors to each movement key according to the direction they correspond to
	#This is used to calculate velocity which is used to move the player
	#This direction is also used to determine the direction the animation should be facing
	#The direction and animation direction are returned
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
	#Depending on the animation direction, plays different animations
	#Plays the idle animation of the side the player was last facing when not moving
	if get_direction(animation_direction)[0] == Vector2(1, 0):
		$AnimatedSprite2D.play("Walk Right")
	elif get_direction(animation_direction)[0] == Vector2(-1, 0):
		$AnimatedSprite2D.play("Walk Left")
	elif get_direction(animation_direction)[0] == Vector2(0, -1):
		$AnimatedSprite2D.play("Walk Up")
	elif get_direction(animation_direction)[0] == Vector2(0, 1):
		$AnimatedSprite2D.play("Walk Down")
	elif get_direction(animation_direction)[0] == Vector2(0, 0):
		$AnimatedSprite2D.play("Idle " + direction)


func _physics_process(delta):
	#Doubles speed when running
	if Input.is_action_pressed("run"):
		speed = 400
	else:
		speed = 200
	#Calls all the functions to update the animation and move the player. The
	#player only moves if they are not caught up in dialogue.
	animation_direction = get_direction(animation_direction)[1]
	get_direction(animation_direction)
	if not_frozen == true:
		move_and_slide()
		walk_cycle(animation_direction)
