extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Something entered portal:", body.name)
	if body.is_in_group("player"):
		print("Player entered portal!")
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
