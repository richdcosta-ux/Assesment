extends Node2D
@export var character_name: String
@export var dialogue_trigger_area: Area2D
@export var character_dialogue_script: GDScript
var character_dialogue 
var dialogue_cooldown = false
signal key_pressed_to_continue_dialogue
func _ready() -> void:
	globalvariables.dialogue_handler = self
	if character_dialogue_script == null:
		push_error("ERROR: No dialogue script assigned for NPC: " + character_name)
		return
	character_dialogue = character_dialogue_script.new()
	
func _input(event: InputEvent) -> void:
	if dialogue_cooldown:
		return
	if is_player_in_dialogue_trigger_area() and event.is_action_pressed("interact"):
		if not globalvariables.is_running_dialogue:
			play_dialogue()
		else:
			key_pressed_to_continue_dialogue.emit()
			

func play_dialogue():
	init_dialogue()

	for dialogue_page in character_dialogue.get_dialogue():
		await play_dialogue_page(dialogue_page)
		
	exit_dialogue()
func play_dialogue_page(dialogue_page):
	globalvariables.dialogue_box.set_dialogue_text(dialogue_page)
	await key_pressed_to_continue_dialogue
func init_dialogue():
	globalvariables.is_running_dialogue = true
	globalvariables.can_move = false
	globalvariables.dialogue_box.visible = true
	globalvariables.dialogue_box_name_tag.text = character_name
func exit_dialogue():
	globalvariables.is_running_dialogue = false
	globalvariables.can_move = true
	globalvariables.dialogue_box.visible = false
	dialogue_cooldown = true
	await get_tree().create_timer(0.3).timeout
	dialogue_cooldown = false
	
func is_player_in_dialogue_trigger_area():
	for body in dialogue_trigger_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false
func next_dialogue_page():
	key_pressed_to_continue_dialogue.emit()
func close_dialogue():
	exit_dialogue()
