extends CanvasLayer

var itemname = ""
var itemdes = ""
var itemcost = 0
var itemcount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func updateinfo():
	get_node("title").text = itemname
	get_node("des").text = itemdes + "\ncost: " + str(itemcost)
	

func _on_close_pressed() -> void:
	get_node("anim").play("transout")
	get_node("../").process_mode = Node.PROCESS_MODE_ALWAYS


func _on_use_pressed() -> void:
	for i in global.inventory:
		if global.inventory[i]["name"] == itemname:
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
