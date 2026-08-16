extends Area2D
@export var character_dialogue_script: GDScript
@export var npc_name: String = "Tutorial NPC"
func get_dialogue():
	return [
		"Hello!",
		"Wellcom to my game. ^^",
		"Try to reach the end by following the tutorial step by step and you will learn the basics of this game.",
		"[hint]: Everything you learn can be applied at once. (DO NOT RUSH)",
		"This game is all about skills.",
		"True Skill Speaks For It Self ! !",
		"Goodluck ! ! "
		
	]
