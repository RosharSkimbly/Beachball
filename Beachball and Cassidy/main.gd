extends Control

var Scene2 = preload('res://beachHall.tscn')
@onready var world = $SubViewportContainer/SubViewport/World

func _ready():
	world.connect('ChangeScene', change)

func change():
	var worldagain = $SubViewportContainer/SubViewport.get_child(0)
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/World)
	worldagain.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene2.instantiate())
