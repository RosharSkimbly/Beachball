extends Node2D

signal battlechange
signal areachange
var indialogue = false
var dialoguearray = ['It\'s some sort of broken robot...', '!!! \nIt began to shudder in place!', 'It weakly tossed itself at you...', 'It seems like it wants to fight.']
var dialoguenumber = 0

func _on_scene_back_body_entered(body: CharacterBody2D) -> void:
	areachange.emit()


func _on_beach_convo_body_entered(body: CharacterBody2D) -> void:
	$Cassidy.speed = 0
	$Cassidy.notfrozen = false
	$Cassidy/AnimatedSprite2D.stop()
	$Cassidy/ColorRect.visible = true
	indialogue = true


func _process(delta):
	$Cassidy/ColorRect/Label.text = dialoguearray[dialoguenumber]
	if indialogue == true:
		if Input.is_action_just_released('click') or Input.is_action_just_released('enter'):
			if dialoguenumber + 1 < len(dialoguearray): 
				dialoguenumber += 1
			else:
				$Cassidy/ColorRect/FadeOut/AnimationPlayer.play("fadeout")


func _ready():
	$Cassidy/ColorRect/TextureRect/AnimationPlayer.play('cursorblink')


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	battlechange.emit()
