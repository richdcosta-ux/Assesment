extends Area2D
@onready var tutorial: Node2D = $"../.."
@export var key_number = 1
@export var key_id = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if key_id in globalvariables.collected_keys:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	if key_number != globalvariables.current_key:
		return
	if key_id not in globalvariables.collected_keys:
		globalvariables.collected_keys.append(key_id)
	save_checkpoint(body)
	globalvariables.current_key += 1
	queue_free()
		
func save_checkpoint(player):
	#tutorial.player_spawn_x = global_position.x
	#tutorial.player_spawn_y = global_position.y
	globalvariables.checkpoint_position = global_position
	print(tutorial.player_spawn_x)
	globalvariables.checkpoint_position = player.global_position
	globalvariables.checkpoint_scene = get_tree().current_scene.scene_file_path
	print("Checkpoint saved at:", globalvariables.checkpoint_position)
	print("Saving to autoload:", globalvariables)
