extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
func open_pause():
	visible = true
	get_tree().paused = true
func close_pause():
	visible = false
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	close_pause()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
