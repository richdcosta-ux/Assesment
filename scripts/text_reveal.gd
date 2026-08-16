extends Node2D

func _ready() -> void:
	$Area2D.area_entered.connect(play_animation)
func play_animation(area: Area2D) -> void:
	$"../jump/jump".play("jump")
