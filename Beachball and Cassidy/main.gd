extends Control

var Scene1 = preload('res://world.tscn')
var Scene2 = preload('res://beachHall.tscn')
var currentscene
@onready var world = $SubViewportContainer/SubViewport/World
signal successiverun

func _ready():
	world.connect('ChangeScene', change)

func change():
	var worldagain = $SubViewportContainer/SubViewport.get_child(0)
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/World)
	worldagain.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene2.instantiate())
	currentscene = $SubViewportContainer/SubViewport.get_child(0)
	currentscene.connect('areachange', areachange)
	currentscene.connect('battlechange', battlechange)
	
func battlechange():
	get_tree().change_scene_to_file('res://battleMenu.tscn')
	


func areachange():
	var worldagain = $SubViewportContainer/SubViewport.get_child(0)
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/beachHall)
	worldagain.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene1.instantiate())
	currentscene = $SubViewportContainer/SubViewport.get_child(0)
	world = $SubViewportContainer/SubViewport/World
	world.connect('ChangeScene', change)
