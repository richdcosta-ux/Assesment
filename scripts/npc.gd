extends Area2D

var player_in_range = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.visible = false
	



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		$Label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		$Label.visible = false

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		open_shop()
func open_shop():
		global.shop_open = true
		get_tree().paused = true
		$shop/anim.play("transin")
