extends CharacterBody2D

@onready var player_animation = $player_animation
var basicattack = false;

var movement = Vector2();
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export var jump_force = -400.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5
@export var dash_speed = 400.0
@export var dash__max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && basicattack == false:
		velocity.y = jump_force
		
	if Input.is_action_just_released("jump"):
		velocity.y *= decelerate_on_jump_release
	
	#Handle speed/movements.
	var speed 
	if Input.is_action_pressed("sprint"):
		speed = run_speed
		$player_animation.play("run")
	else:
		speed = walk_speed
		$player_animation.play("walk")
		
		
	var direction := Input.get_axis("left", "right")
	if direction  && basicattack == false:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		$player_animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
	
	#dash activation
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	#perfoms atual dash
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash__max_distance:
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash__max_distance)
			velocity.y = 0
			$player_animation.play("dash")
	# Reducing the dash timer
	if dash_timer > 0:
		dash_timer -=delta
	move_and_slide()
	var isleft = velocity.x < 0 
	$player_animation.flip_h = isleft
	
	if Input.is_action_pressed("attack"):
		player_attack()
	

func player_attack():
	$player_animation.play("slash")
	basicattack == true
	$attackarea/CollisionShape2D.disabled == false
	await $player_animation.animation_finished

func _on_player_animation_animation_finished() -> void:
	if $player_animation.animation == "slash":
		$attackarea/CollisionShape2D.disabled;
		basicattack = false;
	
		
