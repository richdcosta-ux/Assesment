extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		save_checkpoint(body)
		queue_free()
func save_checkpoint(player):
	globalvariables.checkpoint_position = player.global_position
	globalvariables.checkpoint_scene = get_tree().current_scene.scene_file_path
	print("Checkpoint saved at:", globalvariables.checkpoint_position)
	print("Saving to autoload:", globalvariables)
