extends CharacterBody2D

@onready var player_animation = $player_animation
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

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

func _physics_process(delta: float) -> void:
	if dash_timer > 0: 
		dash_timer -= delta
	if is_dashing:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not basicattack:
		velocity.y = jump_force
		
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
	if basicattack:
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
