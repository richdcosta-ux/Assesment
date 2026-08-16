extends Panel
var itemname = ""
var itemdes = ""
var itemcost = 0
var itemcount = 0
var hasitem = false 
var mouseentered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hasitem == true:
		get_node("icon").texture = global.inventory[get_index()]["icon"]
		get_node("count").text = str(global.inventory[get_index()]["count"])
		get_node("icon").show()
		get_node("count").show()
	else:
		get_node("icon").hide()
		get_node("count").hide()

func _on_mouse_entered() -> void:
	if hasitem == true:
		mouseentered = true


func _on_mouse_exited() -> void:
	mouseentered = false
 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("leftclick"):
		if mouseentered:
			
			get_node("../../iteminfo").itemname = itemname
			get_node("../../iteminfo").itemdes = itemdes
			get_node("../../iteminfo").itemcost = itemcost
			get_node("../../iteminfo").itemcount = itemcount
			get_node("../../iteminfo/anim").play("transin")
			get_node("../../iteminfo").updateinfo()
			get_node("../..").process_mode = Node.PROCESS_MODE_DISABLED
