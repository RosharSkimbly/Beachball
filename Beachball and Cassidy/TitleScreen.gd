extends Control



#When the quit button is released, the game closes
func _on_quit_button_up():
		get_tree().quit()


#When the start button is released, the scene will change to the first scene
func _on_start_button_up():
		get_tree().change_scene_to_file("res://main.tscn")


func _ready():
	#Fades the scene in from darkness
	GlobalNums.first_time = true
	$FadeOut/AnimationPlayer.play("fade_in")
