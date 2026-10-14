extends Control

var player_spawn_x: float = 59.00
var player_spawn_y: float = 702.00
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !global.tutorial_completed:
		$Label3.show()
		$VBoxContainer/start.disabled = true
	else:
		$Label3.hide()
		$VBoxContainer/start.disabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	if !global.tutorial_completed:
		$Label3.show()
		return
	globalvariables.reset_game()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
