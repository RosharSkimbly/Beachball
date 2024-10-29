extends Control

var health = 100
var beachhealth = 100
var scrolling = true
var textarray = ['You\'ve entered battle with the strange robot!', 'It seems to be allowing you to strike first...']
var arraychoice = 0
var inbattle = false
var turn = 0
var accuracy = 100
var beachaccuracy = 100
var firsthalf = 0
var guardup = false
var beachdefense = 1
var skillcooldown = 0
var end = false

func _process(delta):
	$CassidySprite/HealthBar.value = health
	$BeachballSprite/HealthBar.value = beachhealth
	
	if health <= 0:
		$TextMenu/Label.text = 'You have died.'
		end = true
	if beachhealth <= 0:
		$TextMenu/Label.text = 'The robot sputtered out from the fire. You should probably check it out.'
		end = true
	
	if inbattle == false:
		if scrolling == true:
			$TextMenu/FlashingCursor.visible = false
			$TextMenu/Label.visible_characters += 1
			if $TextMenu/Label.visible_characters == len($TextMenu/Label.text):
				arraychoice += 1
				scrolling = false
		else:
			$TextMenu/FlashingCursor.visible = true
			if Input.is_action_just_released('enter') or Input.is_action_just_released('click'):
				if arraychoice > len(textarray) - 1:
					if end == true:
						$ColorRect/AnimationPlayer.play('fade_out')
					elif turn % 2 == 0:
						$TextMenu.visible = false
						$Attack.visible = true
						$Guard.visible = true
						$Skills.visible = true
						$Communicate.visible = true
						$Reason.visible = true
						$ButtonGrid.visible = true
						inbattle = true
					else:
						if beachhealth > 75:
							var beachstrike = randi() % 7 + 2 
							var doesbbhit = randi() % 100 + 1
							if doesbbhit < beachaccuracy:
								if guardup == true:
									health -= beachstrike/5
									$TextMenu/Label.text = 'You braced and only took ' + str(beachstrike/5) + ' damage!'
								else:
									health -= beachstrike
									$TextMenu/Label.text = 'The robot hit for ' + str(beachstrike) + ' damage!'
							else:
								$TextMenu/Label.text = 'The robot missed with its attack!'
							guardup = false
							skillcooldown -= 1
							$TextMenu/Label.visible_characters = 0
							scrolling = true
							turn += 1
							inbattle = false
						elif beachhealth > 50:
							var beachchoice = randi() % 2
							if beachchoice == 0:
								var beachstrike = randi() % 9 + 2
								var doesbbhit = randi() % 100 + 1
								if doesbbhit < beachaccuracy:
									if guardup == true:
										health -= beachstrike/5
										$TextMenu/Label.text = 'You braced and only took ' + str(beachstrike/5) + ' damage!'
									else:
										health -= beachstrike
										$TextMenu/Label.text = 'The robot hit for ' + str(beachstrike) + ' damage!'
								else:
									$TextMenu/Label.text = 'The robot missed with its attack!'
								guardup = false
								skillcooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								inbattle = false
							else: 
								$TextMenu/Label.text  = 'The robot started spewing a strange liquid! Your accuracy was lowered!'
								guardup = false
								skillcooldown -= 1
								accuracy = (accuracy * 3)/4
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								inbattle = false
						else:
							if firsthalf == 0:
								$TextMenu/Label.text = 'The robot sputtered and flailed from its wounds!'
								guardup = false
								skillcooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								firsthalf += 1
								turn += 1
								inbattle = false
							elif firsthalf == 1:
								$TextMenu/Label.text = 'The robot began to combust!'
								guardup = false
								skillcooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								firsthalf += 1
								turn += 1
								inbattle = false
							else:
								var firedamage = randi() % 27 + 4
								var doesbbhit = randi() % 100 + 1
								if doesbbhit < beachaccuracy:
									if guardup == true:
										health -= firedamage/5
										beachhealth -= firedamage/3
										$TextMenu/Label.text = 'You braced and only took ' + str(firedamage/5) + ' damage! The robot took ' + str(firedamage/3) + ' damage in the blaze!'
									else:
										health -= firedamage
										beachhealth -= firedamage/3
										$TextMenu/Label.text = 'You were burned for ' + str(firedamage) + ' damage! The robot took ' + str(firedamage/3) + ' damage in the blaze!'
								else:
									beachhealth -= firedamage/3
									$TextMenu/Label.text = 'The fire missed you but dealt ' + str(firedamage/3) + ' damage to the robot!'
								guardup = false
								skillcooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								inbattle = false
							
							
				else:
					$TextMenu/Label.visible_characters = 0
					$TextMenu/Label.text = textarray[arraychoice]
					scrolling = true
	else:
		pass
		

func _ready():
	$TextMenu/FlashingCursor.visible = false
	$TextMenu/AnimationPlayer.play("pointer_blink")
	$BeachballSprite/AnimationPlayer.play('beachbounce')
	$CassidySprite/AnimationPlayer.play('cassidybounce')


func _on_attack_button_up() -> void:
	if inbattle == true:
		turn += 1
		invisible_menu()
		var attackint = randi() % 8 + 3
		var doeshit = randi() % 100 + 1
		if doeshit > accuracy:
			$TextMenu/Label.text = 'You missed!'
		else:
			beachhealth -= round(attackint * beachdefense)
			$TextMenu/Label.text = 'You struck the robot for ' + str(round(attackint * beachdefense)) + ' damage!'
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		inbattle = false


func _on_guard_button_up() -> void:
	if inbattle == true:
		turn += 1
		invisible_menu()
		guardup = true
		$TextMenu/Label.text = 'You prepared yourself for the next attack.'
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		inbattle = false


func _on_abilities_button_up() -> void:
	if inbattle == true:
		turn += 1
		$Attack.visible = false
		$Guard.visible = false
		$Skills.visible = false
		$Communicate.visible = false
		$Reason.visible = false
		$ButtonGrid/SuckerPunch.visible = true
		$ButtonGrid/PocketSand.visible = true
		$ButtonGrid/LegSweep.visible = true
		$ButtonGrid/Back.visible = true
		$ButtonGrid/Back.disabled = false
		if skillcooldown <= 0:
			$ButtonGrid/SuckerPunch.disabled = false
			$ButtonGrid/PocketSand.disabled = false
			$ButtonGrid/LegSweep.disabled = false


func _on_communicate_button_up() -> void:
	if inbattle == true:
		$Attack.visible = false
		$Guard.visible = false
		$Skills.visible = false
		$Communicate.visible = false
		$Reason.visible = false
		$ButtonGrid/Allies.visible = true
		$ButtonGrid/Allies.disabled = false


func _on_reason_button_up() -> void:
	if inbattle == true:
		turn += 1
		invisible_menu()
		$TextMenu/Label.text = 'You tried to speak to the robot, but it just returned a harsh static...'
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		inbattle = false


func invisible_menu():
	$Attack.visible = false
	$Guard.visible = false
	$Skills.visible = false
	$Communicate.visible = false
	$Reason.visible = false
	$ButtonGrid.visible = false


func _on_sucker_punch_button_up() -> void:
	skillcooldown = 3
	var attackint = randi() % 8 + 3
	var doeshit = randi() % 100 + 1
	if doeshit < accuracy:
		beachhealth -= round(attackint * beachdefense)
		beachdefense += 0.25
		$TextMenu/Label.text = 'You hit the robot for ' + str(round(attackint * beachdefense)) + ' damage and decreased its defense with your wild blow!'
	else:
		$TextMenu/Label.text = 'You missed with your punch!'
	$ButtonGrid/SuckerPunch.visible = false
	$ButtonGrid/PocketSand.visible = false
	$ButtonGrid/LegSweep.visible = false
	$ButtonGrid/Back.visible = false
	$ButtonGrid/SuckerPunch.disabled = true
	$ButtonGrid/PocketSand.disabled = true
	$ButtonGrid/LegSweep.disabled = true
	$ButtonGrid/Back.disabled = true
	$ButtonGrid.visible = false
	$TextMenu/Label.visible_characters = 0
	$TextMenu.visible = true
	scrolling = true
	inbattle = false


func _on_back_button_up() -> void:
		turn -= 1
		$ButtonGrid/SuckerPunch.visible = false
		$ButtonGrid/PocketSand.visible = false
		$ButtonGrid/LegSweep.visible = false
		$ButtonGrid/SuckerPunch.disabled = true
		$ButtonGrid/PocketSand.disabled = true
		$ButtonGrid/LegSweep.disabled = true
		$ButtonGrid/Back.visible = false
		$Attack.visible = true
		$Guard.visible = true
		$Skills.visible = true
		$Communicate.visible = true
		$Reason.visible = true
		$ButtonGrid/Back.disabled = true
		


func _on_pocket_sand_button_up() -> void:
	skillcooldown = 2
	beachaccuracy = beachaccuracy/4
	$TextMenu/Label.text = 'You kicked up a wave of sand! The robot\'s accuracy was lowered!'
	$ButtonGrid/SuckerPunch.visible = false
	$ButtonGrid/PocketSand.visible = false
	$ButtonGrid/LegSweep.visible = false
	$ButtonGrid/Back.visible = false
	$ButtonGrid/SuckerPunch.disabled = true
	$ButtonGrid/PocketSand.disabled = true
	$ButtonGrid/LegSweep.disabled = true
	$ButtonGrid/Back.disabled = true
	$ButtonGrid.visible = false
	$TextMenu/Label.visible_characters = 0
	$TextMenu.visible = true
	scrolling = true
	inbattle = false


func _on_leg_sweep_button_up() -> void:
	skillcooldown = 2
	var attackint = randi() % 4 + 1
	beachhealth -= attackint
	$TextMenu/Label.text = 'You swept your leg to make sure you hit your target! You dealt ' + str(attackint) + ' damage!'
	$ButtonGrid/SuckerPunch.visible = false
	$ButtonGrid/PocketSand.visible = false
	$ButtonGrid/LegSweep.visible = false
	$ButtonGrid/Back.visible = false
	$ButtonGrid/SuckerPunch.disabled = true
	$ButtonGrid/PocketSand.disabled = true
	$ButtonGrid/LegSweep.disabled = true
	$ButtonGrid/Back.disabled = true
	$ButtonGrid.visible = false
	$TextMenu/Label.visible_characters = 0
	$TextMenu.visible = true
	scrolling = true
	inbattle = false


func _on_allies_button_up() -> void:
	$ButtonGrid/Allies.visible = false
	$Attack.visible = true
	$Guard.visible = true
	$Skills.visible = true
	$Communicate.visible = true
	$Reason.visible = true
	$ButtonGrid/Allies.disabled = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file('res://titleScreen.tscn')
