extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var found = false
		for i in global.inventory.keys():
			if global.inventory[i]["name"] == "Health Potion":
				global.inventory[i]["count"] += 1
				found = true
				break
		if not found:
			for slot in range(24):
				if !global.inventory.has(slot):
					var potion_icon = preload("res://assets/loot/Super Pixel Objects Sample/outline_dark/potion_large/potion_A_red_full.png")
					print(potion_icon)
					global.inventory[slot] = {
						"name": "Health Potion",
						"des": "Restores HP",
						"cost": 10,
						"count": 1,
						"icon": potion_icon
					}
					break
		print(global.inventory)
		queue_free()
