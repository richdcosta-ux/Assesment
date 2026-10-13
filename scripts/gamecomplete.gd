extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.visible = false
	$Label2.visible = false
	$Label3.visible = false
	$Button.visible = false
	
	await get_tree().create_timer(1.0).timeout
	$Label.visible = true
	await get_tree().create_timer(1.0).timeout
	$Label2.visible = true
	await get_tree().create_timer(1.0).timeout
	$Label3.visible = true
	$Label3.text = "Enemies Defeated: " + str(global.enemies_defeated)
	await get_tree().create_timer(1.0).timeout
	$Button.visible = true

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
