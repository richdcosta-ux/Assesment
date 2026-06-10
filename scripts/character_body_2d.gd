extends CharacterBody2D

@onready var player_animation = $player_animation
var basicattack = false;

var movement = Vector2();
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	
	if (velocity.x > 1 || velocity.x < -1) && basicattack == false:
		$player_animation.animation = "run"
	
	else:
		movement.x = 0;
		if basicattack == false:
			$player_animation.animation = "idle"
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && basicattack == false:
		velocity.y = JUMP_VELOCITY
		
		
		
	if Input.is_action_just_pressed("attack"):
		$player_animation.play("slash")
		basicattack == true;
		$attackarea/CollisionShape2D.disabled == false;
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction  && basicattack == false:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	var isleft = velocity.x < 0 
	$player_animation.flip_h = isleft
	


func _on_player_animation_animation_finished() -> void:
	if $player_animation.animation == "slash":
		$attackarea/CollisionShape2D.disabled;
		basicattack = false;
	
		
