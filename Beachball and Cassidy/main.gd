extends Control

var Scene_1 = preload("res://world.tscn")
var Scene_2 = preload("res://beachHall.tscn")
var current_scene
@onready var world = $SubViewportContainer/SubViewport/World
signal successive_run


func _ready():
	#Allows this script to access the ChangeScene signal
	world.connect("change_scene", change)


func change():
	#Changes between the first and second rooms by removing the first as a child from
	#the main scene and replacing it with the second, then connecting its signals
	#to make sure the player can go back
	var world_again = $SubViewportContainer/SubViewport.get_child(0)
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/World)
	world_again.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene_2.instantiate())
	current_scene = $SubViewportContainer/SubViewport.get_child(0)
	current_scene.connect("area_change", area_change)
	current_scene.connect("battle_change", battle_change)


func battle_change():
	#When the dialogue with the robot is finished, the whole scene changes to the battle scene
	get_tree().change_scene_to_file("res://battleMenu.tscn")


func area_change():
	#Changes scene from the second area to the first then connects the signals of the first scene
	#to this script so the second area can be accessed again.
	var world_again = $SubViewportContainer/SubViewport.get_child(0)
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/beachHall)
	world_again.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene_1.instantiate())
	current_scene = $SubViewportContainer/SubViewport.get_child(0)
	world = $SubViewportContainer/SubViewport/World
	world.connect("change_scene", change)
