extends Node
var shop_open = false
var gold = 10
var enemies_defeated = 0
var item = {
	0: {
		"name": "Health Potion",
		"des": "(Restores HP)",
		"cost": 10,
		"icon": preload("res://assets/loot/Super Pixel Objects Sample/outline_dark/potion_large/potion_A_red_full.png")

	},
	1: {
		"name": "Speed Potion",
		"des": "(Boosts speed for 30s)",
		"cost": 100,
		"icon": preload("res://assets/loot/Super Pixel Objects Sample/outline_dark/potion_small/potion_C_blue_full.png")
	}
}

var inventory = {}
