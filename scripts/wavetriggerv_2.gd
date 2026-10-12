extends Area2D

@onready var wavemanagerv_2 = get_parent().get_node("wavemanagerv_2")



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		wavemanagerv_2.start_next_wave()
		queue_free()
