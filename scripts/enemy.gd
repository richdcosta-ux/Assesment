extends CharacterBody2D

var death = false;


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if death == false:
		$AnimatedSprite2D.play("idle")
