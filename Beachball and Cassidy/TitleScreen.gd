extends Control

#Makes the menu not be open upon getting to the start menu, once it is implemented
var menuActive = false

#When the quit button is released, the game closes
func _on_quit_button_up():
	if menuActive == false:
		get_tree().quit()

#When the start button is released, the scene will change to the first scene
func _on_start_button_up():
	if menuActive == false:
		get_tree().change_scene_to_file("res://main.tscn")
		

func _ready():
	$FadeOut/AnimationPlayer.play("fade_in")
