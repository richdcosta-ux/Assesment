extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	get_node("anim").play("transout")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if self.offset.y == 600:
			get_node("anim").play("transin")
		elif self.offset.y == -600:
			get_node("anim").play("transin")
		elif self.offset.y == 0:
			get_node("anim").play("transout")
		get_node("invcontainer").fillinventoryslots()
			
