extends Control
@onready var dialogue: RichTextLabel = $dialogue
@onready var name_tag: RichTextLabel = $name_tag
@onready var panel_name_tag: Panel = $panel_name_tag
@onready var panel_dialogue: Panel = $panel_dialogue
var typing := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalvariables.dialogue_box = self 
	visible = false
	globalvariables.dialogue_box_name_tag = name_tag
func set_dialogue_text(text: String):
	typing = true
	dialogue.text = "" 
	var index := 0
	while index < text.length():
		dialogue.text += text[index]
		index += 1
		await get_tree().create_timer(0.03).timeout
	if not typing:
		dialogue.text = text
	typing = false
func _on_next_button_pressed() -> void:
	if typing:
		typing = false   # Instantly finish typing
	else:
		globalvariables.dialogue_handler.next_dialogue_page()


func _on_close_button_pressed() -> void:
	globalvariables.dialogue_handler.close_dialogue()
