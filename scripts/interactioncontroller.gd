extends Area2D

var interactbleinrange = []
@onready var label: Label = $Label
var caninteract = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interactbleinrange.is_empty() == false && caninteract:
			caninteract = false
			label.hide()
			await interactbleinrange.back().interact()
			caninteract = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interactbleinrange.is_empty() == false && caninteract:
		label.show()
	else:
		label.hide()


func _on_area_entered(area: Area2D) -> void:
	interactbleinrange.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	interactbleinrange.erase(area)
