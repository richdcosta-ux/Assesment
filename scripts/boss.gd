extends CharacterBody2D

@onready var healthbar: ProgressBar = $healthbar

signal enemy_died
@export var speed = 50
@export var health = 20
var stunned = false
var stun_timer = 0.0
var player_in_attack_range = false
var player = null
var dead = false
var can_attack = true
var shield_active = false
var used_shield = false
var random_shield_chance = 0.2


func _ready():
	$healthbar.max_value = health
	$healthbar.value = health
	$healthbar.visible = false
	$AnimatedSprite2D.play("spawn")
	can_attack = false
	set_physics_process(false)
	await $AnimatedSprite2D.animation_finished
	set_physics_process(true)
	can_attack = true
	$AnimatedSprite2D.play("idle")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
func _physics_process(delta: float) -> void:
	if dead:
		return
	if shield_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if stunned:
		stun_timer -= delta
		if stun_timer <= 0:
			stunned = false
		move_and_slide()
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed
		$AnimatedSprite2D.flip_h = direction < 0
		if player_in_attack_range:
			if !shield_active and randf() < 0.002:
				activate_shield()
			velocity.x = 0
			if can_attack:
				attack()
		else:
			velocity.x = direction * speed
			if $AnimatedSprite2D.animation != "walk":
				$AnimatedSprite2D.play("walk")
	else:
		velocity.x = 0
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
	move_and_slide()

func attack():
	if !can_attack:
		return
	can_attack = false
	velocity.x = 0
	$AnimatedSprite2D.play("attack")
	await get_tree().create_timer(0.5).timeout
	if player and player_in_attack_range:
		player.take_damage(1)
	$attackcooldown.start()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		take_damage(1)
func take_damage(amount):
	if dead:
		return
	if shield_active:
		return
	health -= amount
	if health <= 10 and !used_shield:
		activate_shield()
		return
	$healthbar.visible = true
	$healthbar.value = health
	stunned = true
	stun_timer = 0.3
	$AnimatedSprite2D.play("take_hit")
	if health <= 0:
		die()
func die():
	dead = true
	enemy_died.emit()
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()


func _on_attackcooldown_timeout() -> void:
	can_attack = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false


func _on_animated_sprite_2d_animation_finished() -> void:
		if dead:
			return
		match $AnimatedSprite2D.animation:
			"attack":
				$AnimatedSprite2D.play("idle")
			"take_hit":
				$AnimatedSprite2D.play("idle")
			"shield":
				$AnimatedSprite2D.play("idle")
func activate_shield():
	used_shield = true
	shield_active = true
	stunned = false
	can_attack = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("shield")
	await $AnimatedSprite2D.animation_finished
	print("SHIELD ACTIVE")
	await get_tree().create_timer(0.0).timeout
	print("SHIELD ENDED")
	shield_active = false
	can_attack = true
	$AnimatedSprite2D.play("idle")


func _on_shieldtimer_timeout() -> void:
	if dead:
		return
	if shield_active:
		return
	if randf() < 0.4:
		activate_shield()
