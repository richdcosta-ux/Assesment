extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var isopen = false

func interact():
	if isopen == false:
		$AnimatedSprite2D.play("open")
		await $AnimatedSprite2D.animation_finished
		isopen = true 
	else:
		$AnimatedSprite2D.play("close")
		await $AnimatedSprite2D.animation_finished
		isopen = false
