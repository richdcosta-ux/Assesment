extends CanvasLayer
var currentitem = 0 
var select = 0
func _on_button_pressed() -> void:
	global.shop_open = false
	$anim.play("transout")
	get_tree().paused = false

func switchitem(select):
	if select < 0:
		select = global.item.size() - 1
	elif select >= global.item.size():
		select = 0
	for i in range(global.item.size()):
		if select == i:
			currentitem = select
			get_node("Control/animsprite").play(global.item[currentitem]["name"])
			get_node("Control/name").text = global.item[currentitem]["name"]
			get_node("Control/des").text = global.item[currentitem]["des"]
			get_node("Control/des").text +="\nCost: " + str(global.item[currentitem]["cost"])

func _on_next_pressed() -> void:
	switchitem(currentitem+1)


func _on_prev_pressed() -> void:
	switchitem(currentitem-1)


func _on_buy_pressed() -> void:
	var hasitem = false
	if global.gold >= global.item[currentitem]["cost"]:
		for i in global.inventory:
			if global.inventory[i]["name"] == global.item[currentitem]["name"]:
				global.inventory[i]["count"] += 1
				hasitem = true
				break
		if not hasitem:
			var new_item = {
				"name": global.item[currentitem]["name"],
				"des": global.item[currentitem]["des"],
				"cost": global.item[currentitem]["cost"],
				"icon": global.item[currentitem]["icon"],
				"count": 1
			}
			global.inventory[global.inventory.size()] = new_item
		
		global.gold -= global.item[currentitem]["cost"]
	print(global.inventory)
		
			
