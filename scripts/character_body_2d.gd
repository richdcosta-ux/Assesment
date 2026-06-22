extends CharacterBody2D

@onready var portal = $portal
@onready var player_animation = $player_animation
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var sprite = $player_animation

@export var walk_speed = 150.0
@export var run_speed = 250.0
@export var jump_force = -400.0
@export var dash_speed = 400.0
@export var dash_max_distance = 100.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

@export_range(0, 1) var acceleration = 0.2
@export_range(0, 1) var deceleration = 0.2
@export_range(0, 1) var decelerate_on_jump_release = 0.5

var basicattack = false;
var movement = Vector2();
var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0
var jumps_left = 1 
var on_wall = false
var wall_direction = 0
var is_wall_clinging = false


func _physics_process(delta: float) -> void:
	if dash_timer > 0: 
		dash_timer -= delta
	if is_dashing:
		return
	# Add the gravity.
	if not is_on_floor():
		if on_wall and velocity.y > 0:
			velocity.y = min(velocity.y, 80)
		else:
			velocity += get_gravity() * delta
	if is_on_floor():
		jumps_left = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and not basicattack:
		if is_on_floor():
			velocity.y = jump_force
		elif on_wall:
			velocity.y = jump_force
			velocity.x = -wall_direction * run_speed
			
		elif jumps_left > 0:
			velocity.y = jump_force
			jumps_left -= 1
		
	if Input.is_action_just_released("jump"):
		velocity.y *= decelerate_on_jump_release
		
		
		
	
	#Handle speed/movements.
	var speed 
	if Input.is_action_pressed("sprint"):
		speed = run_speed
		
	else:
		speed = walk_speed
		
		
		
	var direction := Input.get_axis("left", "right")
	if direction != 0 and not basicattack:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	on_wall = false
	if is_on_wall_only():
		on_wall = true
		wall_direction = sign(get_last_slide_collision().get_normal().x)
	if on_wall and not is_on_floor() and velocity.y > 0 and not basicattack:
		is_wall_clinging = true
		sprite.rotation_degrees = wall_direction * -15
		sprite.scale = Vector2(0.9, 1.1)
		sprite.position.x = wall_direction * -6
		player_animation.play("idle")
		player_animation.flip_h = wall_direction == 1
	else:
		is_wall_clinging = false
		sprite.rotation_degrees = 0
		sprite.scale = Vector2(1, 1)
		sprite.position.x = 0
	
	
	
	if basicattack:
		pass
	elif is_wall_clinging:
		pass
	else:
		if direction != 0:
			$player_animation.play("run" if speed == run_speed else "walk")
		else:
			$player_animation.play("idle")
		
	$player_animation.flip_h = velocity.x < 0
	
	if Input.is_action_just_pressed("dash") and direction != 0 and dash_timer <= 0:
		start_dash(direction)
	if Input.is_action_just_pressed("attack") and not basicattack and not is_dashing:
		player_attack()
	
func start_dash(direction) -> void:
	#dash activation
		is_dashing = true
		dash_timer = dash_cooldown
		$ShapeCast2D.target_position = Vector2(direction * dash_max_distance, 0)
		$ShapeCast2D.force_shapecast_update()
		
		var target_position: Vector2
		if $ShapeCast2D.is_colliding():
			var safe_fraction = $ShapeCast2D.get_closest_collision_safe_fraction()
			target_position = global_position + Vector2(direction * dash_max_distance * safe_fraction, 0)
		else:
		# Path is completely clear
			target_position = global_position + Vector2(direction * dash_max_distance, 0)
			
		set_collision_layer_value(1, false) # Adjust to your collision mask
		$player_animation.play("dash")
		
		var tween = create_tween()
		var actual_distance = global_position.distance_to(target_position)
		tween.tween_property(self, "global_position", target_position, actual_distance / dash_speed)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		tween.tween_callback(end_dash)
	
func end_dash() -> void:
	is_dashing = false
	set_collision_layer_value(1, true)
	
func player_attack():
	basicattack = true
	$player_animation.play("slash")
	$attackarea/CollisionShape2D.disabled = false
	await $player_animation.animation_finished

func _on_player_animation_animation_finished() -> void:
	if $player_animation.animation == "slash":
		$attackarea/CollisionShape2D.disabled = true
		basicattack = false
