extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var next_scene : String
@export var completes_tutorial := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if completes_tutorial:
			global.tutorial_completed = true
		get_tree().change_scene_to_file(next_scene)
