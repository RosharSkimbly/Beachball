extends Control

var health = 100
var beach_health = 100
var scrolling = true
var text_array = [
	"You've entered battle with the strange robot!",
	"It seems to be allowing you to strike first..."
]
var array_choice = 0
var in_battle = false
var turn = 0
var accuracy = 100
var beach_accuracy = 100
var first_half = 0
var guard_up = false
var beach_defense = 1
var skill_cooldown = 0
var end = false


func _process(delta):
	#Constantly keeps health updated whenever it changes
	$CassidySprite/HealthBar.value = health
	$BeachballSprite/HealthBar.value = beach_health

#Breaks the turn loop if one of the parties dies and takes the player back to the main menu
	if health <= 0:
		$TextMenu/Label.text = "You have died."
		end = true
	if beach_health <= 0:
		$TextMenu/Label.text = "The robot sputtered out from the fire. You should probably check it out."
		end = true

	if in_battle == false:
		#Causes the text displayed to take time to scroll across the box before being allowed to skip
		if scrolling == true:
			$TextMenu/FlashingCursor.visible = false
			$TextMenu/Label.visible_characters += 1
			#Once all characters are accounted for, it moves on
			if $TextMenu/Label.visible_characters == len($TextMenu/Label.text):
				array_choice += 1
				scrolling = false
		else:
			#Creates a state where the player can read the text and continue by clicking
			#or hitting enter or z. It changes the state to the player's turn if all
			#dialogue options have been exhausted.
			$TextMenu/FlashingCursor.visible = true
			if Input.is_action_just_released("enter") or Input.is_action_just_released("click"):
				if array_choice > len(text_array) - 1:
					if end == true:
						$ColorRect/AnimationPlayer.play("fade_out")
					elif turn % 2 == 0:
						$TextMenu.visible = false
						$Attack.visible = true
						$Guard.visible = true
						$Skills.visible = true
						$Communicate.visible = true
						$Reason.visible = true
						$ButtonGrid.visible = true
						in_battle = true
					else:
						#After the player uses one of the buttons, their response is handled with
						#The scrolling text functions above, and then it is the enemy's turn.
						#Depending on its health, it has 3 different levels of behaviour.
						if beach_health > 75:
							#If the enemy's health is above 75, it deals a random amount 
							#of damage each turn, from 2 - 8.
							#Calculates for hit chance based on accuracy and takes
							#into account if the player is guarding.
							var beach_strike = randi() % 7 + 2
							var does_bb_hit = randi() % 100 + 1
							if does_bb_hit < beach_accuracy:
								if guard_up == true:
									health -= beach_strike / 5
									$TextMenu/Label.text = (
										"You braced and only took "
										+ str(beach_strike / 5)
										+ " damage!"
									)
								else:
									health -= beach_strike
									$TextMenu/Label.text = (
										"The robot hit for " + str(beach_strike) + " damage!"
									)
							else:
								$TextMenu/Label.text = "The robot missed with its attack!"
							#Resets guard and lowers skill cooldowns, then lets the earlier scrolling
							#function handle the text output before handing off again to the player's turn
							#This happens in the same way for every one of the robot's options.
							guard_up = false
							skill_cooldown -= 1
							$TextMenu/Label.visible_characters = 0
							scrolling = true
							turn += 1
							in_battle = false
						elif beach_health > 50:
							#If the enemy has 75-50 health, it has 2 options, determined by a 
							#random number generator, either to deal from 2-10 damage, or to lower
							#the player's accuracy.
							var beach_choice = randi() % 2
							if beach_choice == 0:
								var beach_strike = randi() % 9 + 2
								var does_bb_hit = randi() % 100 + 1
								if does_bb_hit < beach_accuracy:
									if guard_up == true:
										health -= beach_strike / 5
										$TextMenu/Label.text = (
											"You braced and only took "
											+ str(beach_strike / 5)
											+ " damage!"
										)
									else:
										health -= beach_strike
										$TextMenu/Label.text = (
											"The robot hit for " + str(beach_strike) + " damage!"
										)
								else:
									$TextMenu/Label.text = "The robot missed with its attack!"
								guard_up = false
								skill_cooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								in_battle = false
							else:
								$TextMenu/Label.text = "The robot started spewing a strange liquid! Your accuracy was lowered!"
								guard_up = false
								skill_cooldown -= 1
								accuracy = (accuracy * 3) / 4
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								in_battle = false
						else:
							#Below 50 health, the enemy first takes a turn where it idles
							if first_half == 0:
								$TextMenu/Label.text = "The robot sputtered and flailed from its wounds!"
								guard_up = false
								skill_cooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								first_half += 1
								turn += 1
								in_battle = false
							elif first_half == 1:
								#This next turn is also idle
								$TextMenu/Label.text = "The robot began to combust!"
								guard_up = false
								skill_cooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								first_half += 1
								turn += 1
								in_battle = false
							else:
								#After idling for 2 turns, the enemy deals between 4-30
								#damage each turn and deals a third of that to itself.
								var fire_damage = randi() % 27 + 4
								var does_bb_hit = randi() % 100 + 1
								if does_bb_hit < beach_accuracy:
									if guard_up == true:
										health -= fire_damage / 5
										beach_health -= fire_damage / 3
										$TextMenu/Label.text = (
											"You braced and only took "
											+ str(fire_damage / 5)
											+ " damage! The robot took "
											+ str(fire_damage / 3)
											+ " damage in the blaze!"
										)
									else:
										health -= fire_damage
										beach_health -= fire_damage / 3
										$TextMenu/Label.text = (
											"You were burned for "
											+ str(fire_damage)
											+ " damage! The robot took "
											+ str(fire_damage / 3)
											+ " damage in the blaze!"
										)
								else:
									beach_health -= fire_damage / 3
									$TextMenu/Label.text = (
										"The fire missed you but dealt "
										+ str(fire_damage / 3)
										+ " damage to the robot!"
									)
								guard_up = false
								skill_cooldown -= 1
								$TextMenu/Label.visible_characters = 0
								scrolling = true
								turn += 1
								in_battle = false

				else:
					#If there is still more text to read, moves on to the next bit
					#of text when the player clicks
					$TextMenu/Label.visible_characters = 0
					$TextMenu/Label.text = text_array[array_choice]
					scrolling = true
	else:
		pass


func _ready():
	#Plays all the constantly looping animations from the start of the scene
	#Also makes sure the FlashingCursor node is not visible
	$TextMenu/FlashingCursor.visible = false
	$TextMenu/AnimationPlayer.play("pointer_blink")
	$BeachballSprite/AnimationPlayer.play("beachbounce")
	$CassidySprite/AnimationPlayer.play("cassidybounce")


func _on_attack_button_up() -> void:
	#When the attack button is pressed, damage between 3-10 is calculated and then applied
	#to the enemy, taking into account accuracy and the state of the enemy's defense stat
	#It then hands back over to the _process function to handle the text
	if in_battle == true:
		turn += 1
		invisible_menu()
		var attack_int = randi() % 8 + 3
		var does_hit = randi() % 100 + 1
		if does_hit > accuracy:
			$TextMenu/Label.text = "You missed!"
		else:
			beach_health -= round(attack_int * beach_defense)
			$TextMenu/Label.text = (
				"You struck the robot for " + str(round(attack_int * beach_defense)) + " damage!"
			)
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		in_battle = false


func _on_guard_button_up() -> void:
	#Sets the guardup value to true, reducing damage taken on the next attack
	#Hands back over to the _process function to handle the text
	if in_battle == true:
		turn += 1
		invisible_menu()
		guard_up = true
		$TextMenu/Label.text = "You prepared yourself for the next attack."
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		in_battle = false


func _on_abilities_button_up() -> void:
	#Opens up and activates a whole other menu of buttons, allowing the skills
	#detailed in them to be used with a click if the skill cooldown is not active
	if in_battle == true:
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
		if skill_cooldown <= 0:
			$ButtonGrid/SuckerPunch.disabled = false
			$ButtonGrid/PocketSand.disabled = false
			$ButtonGrid/LegSweep.disabled = false


func _on_communicate_button_up() -> void:
	#Currently, this button has no use as the player does not have any allies.
	#It just activates a button that leads back to the player menu when pressed
	#with some explaining text
	if in_battle == true:
		$Attack.visible = false
		$Guard.visible = false
		$Skills.visible = false
		$Communicate.visible = false
		$Reason.visible = false
		$ButtonGrid/Allies.visible = true
		$ButtonGrid/Allies.disabled = false


func _on_reason_button_up() -> void:
	#Spends a turn of the player's and has no effect on the battle, just hands
	#over to the _process function to process its resulting text
	if in_battle == true:
		turn += 1
		invisible_menu()
		$TextMenu/Label.text = "You tried to speak to the robot, but it just returned a harsh static..."
		$TextMenu/Label.visible_characters = 0
		$TextMenu.visible = true
		scrolling = true
		in_battle = false


func invisible_menu():
	#Contains the information to get rid of the visibility of the player's option
	#buttons. Used for efficiency, to shorten some code.
	$Attack.visible = false
	$Guard.visible = false
	$Skills.visible = false
	$Communicate.visible = false
	$Reason.visible = false
	$ButtonGrid.visible = false


func _on_sucker_punch_button_up() -> void:
	#Sets a skill cooldown, stopping the user from using skills for 3 turns, then
	#deals normal 3-10 damage, accounting for accuracy and defense, but lowers the 
	#target's defense stat when used, meaning they take more damage from attacks.
	#It then disables and turns its menu invisible before handing back over to the
	#_process function to handle the text.
	skill_cooldown = 3
	var attack_int = randi() % 8 + 3
	var does_hit = randi() % 100 + 1
	if does_hit < accuracy:
		beach_health -= round(attack_int * beach_defense)
		beach_defense += 0.25
		$TextMenu/Label.text = (
			"You hit the robot for "
			+ str(round(attack_int * beach_defense))
			+ " damage and decreased its defense with your wild blow!"
		)
	else:
		$TextMenu/Label.text = "You missed with your punch!"
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
	in_battle = false


func _on_back_button_up() -> void:
	#Exits back from the skills menu to the main battle menu
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
	#Creates a 2-turn skill cooldown, cuts the enemy's accuracy by 1/4, then 
	#makes its menu invisible and unusable before handing off to _process to take
	#care of the text
	skill_cooldown = 2
	beach_accuracy = (beach_accuracy / 4) * 3
	$TextMenu/Label.text = "You kicked up a wave of sand! The robot's accuracy was lowered!"
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
	in_battle = false


func _on_leg_sweep_button_up() -> void:
	#Similar to attacking normally, this button deals a range of 1-4 damage, but
	#does not take accuracy into account, warranting it a 2-turn skill cooldown.
	#It then makes the menu disappear and become unusable before handing over to
	#_process to handle the text.
	skill_cooldown = 2
	var attack_int = randi() % 4 + 1
	beach_health -= attack_int
	$TextMenu/Label.text = (
		"You swept your leg to make sure you hit your target! You dealt "
		+ str(attack_int)
		+ " damage!"
	)
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
	in_battle = false


func _on_allies_button_up() -> void:
	#Sends the player back to their menu if they click on the button that appears
	#when they click on communicate.
	$ButtonGrid/Allies.visible = false
	$Attack.visible = true
	$Guard.visible = true
	$Skills.visible = true
	$Communicate.visible = true
	$Reason.visible = true
	$ButtonGrid/Allies.disabled = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#When the player wins or loses, after the scene fades, the scene changes to the title screen
	get_tree().change_scene_to_file("res://titleScreen.tscn")
