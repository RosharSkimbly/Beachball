extends Control

var Scene2 = preload('res://beachHall.tscn')
@onready var world = $SubViewportContainer/SubViewport/World

func _ready():
	world.connect('ChangeScene', change)

func change():
	$SubViewportContainer/SubViewport.remove_child($SubViewportContainer/SubViewport/World)
	$SubViewportContainer/SubViewport/World.queue_free()
	$SubViewportContainer/SubViewport.add_child(Scene2.instantiate())
