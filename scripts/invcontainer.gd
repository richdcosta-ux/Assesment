extends GridContainer

@onready var item = preload("res://prefabs/slot.tscn")
var invsize = 24
func _ready():
	for i in range(invsize):
		var itemtemp = item.instantiate()
		add_child(itemtemp)
	fillinventoryslots()
func fillinventoryslots():
	#empty all the slots for item 
	for i in range(invsize):
		get_child(i).itemname = ""
		get_child(i).itemdes = ""
		get_child(i).itemcost = 0
		get_child(i).itemcount = 0
		get_child(i).hasitem = false 
	
	#fills inv into slots
	var keys = global.inventory.keys()
	keys.sort()
	for i in keys:
		get_child(i).itemname = global.inventory[i]["name"]
		get_child(i).itemdes = global.inventory[i]["des"]
		get_child(i).itemcost = global.inventory[i]["cost"]
		get_child(i).itemcount = global.inventory[i]["count"]
		get_child(i).get_node("count").text = str(global.inventory[i]["count"])
		get_child(i).get_node("icon").texture = global.inventory[i]["icon"]
		get_child(i).hasitem = true
