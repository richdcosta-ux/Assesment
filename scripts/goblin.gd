extends CharacterBody2D
signal enemy_died
@export var speed := 80
@export var health := 4
@onready var healthbar: ProgressBar = $healthbar
@export var health_potion_scene : PackedScene

var knockback_force = 250
var stunned = false
var stun_timer = 0.0
var player = null
var player_in_attack_range = false
var dead = false
var can_attack = true


func _ready() -> void:
	velocity = Vector2.ZERO
	$healthbar.visible = false
	healthbar.init_health(health)


func _physics_process(delta: float) -> void:
	if stun_timer > 0:
		stun_timer -= delta
		move_and_slide()
		return
	if dead:
		return
	if global_position.y > 2000:
		die()
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0
	velocity.y = min(velocity.y, 1000)
	velocity.x = move_toward(velocity.x, 0, 800 * delta)
	if stunned:
		stun_timer -= delta
		velocity.x = 0
		if stun_timer <= 0:
			stunned = false
		move_and_slide()
		return
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		var distance = abs(player.global_position.x - global_position.x)
		$AnimatedSprite2D.flip_h = direction < 0
		if distance > 60:
			velocity.x = direction * speed
			$AnimatedSprite2D.play("run")
		else:
			velocity.x = 0
			if player_in_attack_range and can_attack:
				attack()
		move_and_slide()
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
		
func attack():
	can_attack = false
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(0.4).timeout
	if player and is_instance_valid(player):
		player.take_damage(1)
	$attackcooldown.start()
	can_attack = true
func take_damage(amount, attacker_position):
	if dead:
		return
	health -= amount
	var direction = sign(global_position.x - attacker_position.x)
	velocity.x = direction * 100
	stunned = true
	stun_timer = 0.3
	$healthbar.visible = true
	if health <= 0:
		die()
	else:
		$AnimatedSprite2D.play("take_hit")
	healthbar.health = health
func die():
	dead = true
	global.gold += 1
	global.enemies_defeated += 1
	enemy_died.emit()
	if randf() < 0.1:
		var potion = health_potion_scene.instantiate()
		potion.global_position = global_position
		get_tree().current_scene.add_child(potion)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true



func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword") and not dead:
		take_damage(1, area.global_position)


func _on_attackcooldown_timeout() -> void:
	can_attack = true
