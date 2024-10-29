extends Node2D

signal battle_change
signal area_change
var in_dialogue = false
var dialogue_array = [
	"It's some sort of broken robot...",
	"!!! \nIt began to shudder in place!",
	"It weakly tossed itself at you...",
	"It seems like it wants to fight."
]
var dialogue_number = 0


func _on_scene_back_body_entered(body: CharacterBody2D) -> void:
	#Changes the scene to the connecting room when the player hits the border
	area_change.emit()


func _on_beach_convo_body_entered(body: CharacterBody2D) -> void:
	#A bit of text occurs in a box when the player crosses a trigger at the far left
	#end of the scene, causing them to stop moving or animating.
	$Cassidy.speed = 0
	$Cassidy.not_frozen = false
	$Cassidy/AnimatedSprite2D.stop()
	$Cassidy/ColorRect.visible = true
	in_dialogue = true


func _process(delta):
	#The dialogue constantly updates to its correct text
	$Cassidy/ColorRect/Label.text = dialogue_array[dialogue_number]
	#Allows the player to click through the text, fading the scene out once the dialogue finishes
	if in_dialogue == true:
		if Input.is_action_just_released("click") or Input.is_action_just_released("enter"):
			if dialogue_number + 1 < len(dialogue_array):
				dialogue_number += 1
			else:
				$Cassidy/ColorRect/FadeOut/AnimationPlayer.play("fadeout")


func _ready():
	#Starts constantly looping animation at the start of the scene
	$Cassidy/ColorRect/TextureRect/AnimationPlayer.play("cursorblink")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#Once the scene is done fading out, it is changed to the battle scene
	battle_change.emit()
