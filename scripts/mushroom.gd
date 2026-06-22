extends Area2D


var health = 3
var dead = false;


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword") and not dead:
		health -= 1
		if health <= 0:
			dead = true
			$AnimatedSprite2D.play("death")
		else:
			$AnimatedSprite2D.play("take_hit")
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "take_hit":
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "death":
		queue_free()
