extends CharacterBody2D

signal enemy_died

@export var speed = 120
@export var health = 2
@export var health_potion_scene : PackedScene

@onready var healthbar: ProgressBar = $healthbar


var attacking = false
var dying = false
var stunned = false
var stun_timer = 0.0
var knockback_force = 250
var hurt = false
var hover_time = 0.0
var player = null
var player_in_attack_range = false
var dead = false
var can_attack = true

func _ready():
	healthbar.visible = false
	healthbar.max_value = health
	healthbar.value = health

func _physics_process(delta: float) -> void:
	if dying:
		velocity.y += 800 * delta
		move_and_slide()
		if global_position.y > 2000:
			queue_free()
		return
		if global_position.y > 2000:
			queue_free()
		return
	if dead:
		return
	if stunned:
		stun_timer -= delta
		move_and_slide()
		if stun_timer <= 0:
			stunned = false
		return
	if player and not attacking:
		var direction = (player.global_position - global_position).normalized()
		$AnimatedSprite2D.flip_h = direction.x < 0
		if $AnimatedSprite2D.animation == "attack":
			move_and_slide()
			return
		if global_position.distance_to(player.global_position) > 50:
			hover_time += delta
			velocity = direction * speed
			velocity.y += sin(hover_time * 8) * 40
			if $AnimatedSprite2D.animation != "attack":
				$AnimatedSprite2D.play("flight")
		else:
			velocity = Vector2.ZERO
			if player_in_attack_range and can_attack:
				attack()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("flight")
	move_and_slide()
func attack():
	can_attack = false
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	if player and is_instance_valid(player) and player_in_attack_range:
		player.take_damage(1)
	if not dead:
		$AnimatedSprite2D.play("flight")
	$attackcooldown.start()

	if not dead:
		$AnimatedSprite2D.play("flight")
	$attackcooldown.start()
func take_damage(amount, attacker_position):
	if dead:
		return
	health -= amount
	healthbar.visible = true
	healthbar.value = health
	var direction = sign(global_position.x - attacker_position.x)
	velocity.x = direction * knockback_force
	velocity.y = -80
	stunned = true
	stun_timer = 0.6
	if health <= 0:
		die()
	else:
		$AnimatedSprite2D.play("take_hit")
		await $AnimatedSprite2D.animation_finished
		if not dead:
			$AnimatedSprite2D.play("flight")
func die():
	if dying:
		return
	dying = true
	dead = true
	global.enemies_defeated += 1
	enemy_died.emit()
	if randf() < 0.1:
		var potion = health_potion_scene.instantiate()
		potion.global_position = global_position
		get_tree().current_scene.add_child(potion)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	while global_position.y < 2000:
		velocity.y += 800 * get_process_delta_time()
		move_and_slide()
		await get_tree().process_frame
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
	if area.is_in_group("sword"):
		take_damage(1, area.global_position)


func _on_attackcooldown_timeout() -> void:	
	can_attack = true
