extends Control


func _on_quit_button_up():
	"""When the quit button is released, the game closes
		"""
	get_tree().quit()


func _on_start_button_up():
	"""When the start button is released, the scene will change to the 
		first scene
		"""
	get_tree().change_scene_to_file("res://main.tscn")


func _ready():
	"""Fades the scene in from darkness when it starts
	"""
	GlobalNums.first_time = true
	$FadeOut/AnimationPlayer.play("fade_in")


func _on_instructions_button_up() -> void:
	"""Opens the instructions menu to inform the users about the controls and
	point of the game
	"""
	$Instructions/InstructionBack.visible = true


func _on_instruction_exit_button_up() -> void:
	"""Closes the instruction menu when the close button is pressed
	"""
	$Instructions/InstructionBack.visible = false
