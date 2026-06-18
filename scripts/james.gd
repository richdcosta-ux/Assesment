extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var shapecast: ShapeCast2D = $ShapeCast2D

@export var dash_distance: float = 200.0
@export var dash_damage: float = 205.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("dash"):
		var dash_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		perform_dash(dash_direction)
	move_and_slide()


func perform_dash(dash_direction: Vector2):
	if dash_direction == Vector2.ZERO:
		# Default to forward if no movement input is active
		dash_direction = Vector2.RIGHT
	
	dash_direction = dash_direction.normalized()
	
	# 1. Configure the ShapeCast target position
	shapecast.add_exception(self)
	
	# 2. Force the ShapeCast to update immediately
	shapecast.force_shapecast_update()
	
	# 3. Process interactions with things we dashed through
	if shapecast.is_colliding():
		_handle_dash_collisions()
		
		# 4. Move to the safe collision point (prevents clipping into walls)
		# get_closest_collision_safe_fraction() returns a 0.0-1.0 multiplier
		var safe_fraction = shapecast.get_closest_collision_safe_fraction()
		global_position += shapecast.target_position * safe_fraction
	else:
		# No walls hit, move full distance
		global_position += shapecast.target_position


func _handle_dash_collisions():
	# Loop through every unique object the shape passed through
	for i in shapecast.get_collision_count():
		var hit_object = shapecast.get_collider(i)
		
		# Example: Damage enemies passed during the dash
		if hit_object.has_method("take_damage"):
			var hit_point = shapecast.get_collision_point(i)
			hit_object.take_damage(dash_damage, hit_point)
