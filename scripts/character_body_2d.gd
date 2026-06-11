extends CharacterBody2D

@onready var player_animation = $player_animation
var basicattack = false;

var movement = Vector2();
@export var walk_speed = 200.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && basicattack == false:
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("attack"):
		player_attack()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction  && basicattack == false:
		velocity.x = move_toward(velocity.x, direction * walk_speed, walk_speed * acceleration)
		$player_animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		$player_animation.play("idle")
	move_and_slide()
	
	var isleft = velocity.x < 0 
	$player_animation.flip_h = isleft
	

func player_attack():
	$player_animation.play("slash")
	basicattack == true
	$attackarea/CollisionShape2D.disabled == false
	await $player_animation.animation_finished

func _on_player_animation_animation_finished() -> void:
	if $player_animation.animation == "slash":
		$attackarea/CollisionShape2D.disabled;
		basicattack = false;
	
		
