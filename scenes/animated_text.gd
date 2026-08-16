extends Node2D
var labels = []
var anim_names = ["a_d", "space", "sprint", "high_jump", "dash", "double_jump","inventory", "attack", "end",]
var current = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labels = [$Label, $Label2, $Label3, $Label4, $Label5, $Label7, $Label16, $Label6, $Label9,]
	for l in labels:
		l.visible = false
	labels[0].get_node("Area2D").body_entered.connect(_on_area_triggered)
func _on_area_triggered(body):
	var label = labels[current]
	label.visible = true
	label.get_node("AnimationPlayer").play(anim_names[current])
	var area = label.get_node("Area2D")
	label.get_node("Area2D").set_deferred("monitoring", false)
	label.get_node("Area2D").set_deferred("monitorable", false)
	current += 1
	if current < labels.size():
		labels[current].get_node("Area2D").body_entered.connect(_on_area_triggered)
