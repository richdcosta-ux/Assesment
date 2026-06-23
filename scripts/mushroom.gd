extends Area2D


var health = 3
var dead = false;
var can_attack = true
var attack_cooldown = 0.8
var player_in_range = false

	
func _process(delta: float) -> void:
	if player_in_range and can_attack and not dead:
		attack()
func attack():
	can_attack = false
	$AnimatedSprite2D.play("attack")
	if player_in_range:
		get_tree().call_group("player", "take_damage", 1)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true



func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		
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
	if $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "death":
		queue_free()
