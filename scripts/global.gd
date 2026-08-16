extends Node
var shop_open = false
var gold = 1000
var item = {
	0: {
		"name": "Apple",
		"des": "(Regenerates health)",
		"cost": 50,
		"icon": preload("res://assets/Pixel Adventure 1/Free/Items/Fruits/Apple.png")
	},
	1: {
		"name": "Speed Potion",
		"des": "(Boosts speed for 30s)",
		"cost": 100,
		"icon": preload("res://assets/loot/Super Pixel Objects Sample/outline_dark/potion_small/potion_C_blue_full.png")
	}
}

var inventory = {
	0: {
		"name": "Apple",
		"des": "(Regenerates health)",
		"cost": 50,
		"icon": preload("res://assets/Pixel Adventure 1/Free/Items/Fruits/Apple.png"),
		"count": 1
	},
}
