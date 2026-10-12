extends CanvasLayer

var itemname = ""
var itemdes = ""
var itemcost = 0
var itemcount = 0
var itemicon
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func updateinfo():
	get_node("title").text = itemname
	get_node("des").text = itemdes + "\ncost: " + str(itemcost)
	get_node("icon").texture = itemicon

func _on_close_pressed() -> void:
	get_node("anim").play("transout")
	get_node("../").process_mode = Node.PROCESS_MODE_ALWAYS


func _on_use_pressed() -> void:
	for i in global.inventory:
		if global.inventory[i]["name"] == itemname:
			if itemname == "Health Potion":
				print(itemname)
				print("HEALING")
				var player = get_tree().get_first_node_in_group("player")
				if player:
					player.health += 3
					player.health = min(player.health, player.max_health)
					player.update_health_bar()
					print("Player healed:", player.health)
			itemcount -= 1
			if itemcount == 0:
				#remove items from in then upd the inv
				var tempdec = {}
				for x in global.inventory:
					if x > i:
						tempdec[x-1] = global.inventory[x]
					elif x < i:
						tempdec[x] = global.inventory[x]
				global.inventory.clear()
				global.inventory = tempdec
			else:
				global.inventory[i]["count"] -= 1
			get_node("../invcontainer").fillinventoryslots()
