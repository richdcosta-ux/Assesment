extends Area2D

@onready var wavemanager: Node2D = $"../wavemanager"



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		wavemanager.start_next_wave()
		queue_free()
