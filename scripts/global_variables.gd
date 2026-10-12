extends Node
var visible = false
var dialogue_box
var dialogue_box_name_tag  
var is_running_dialogue = false
var can_move = true 
var dialogue_handler
var checkpoint_position: Vector2 = Vector2(59.0,702.0)
var checkpoint_scene: String = ""
func reset_game():
	checkpoint_position = Vector2(50, 700)
	checkpoint_scene = ""
var should_respawn := false
