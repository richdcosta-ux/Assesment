extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var health_potion_scene : PackedScene
@onready var reward_label = $rewardlabel
var isopen = false

func interact():
	if isopen:
		return
	isopen = true 
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	var reward = randi_range(0, 1)
	if reward == 0:
		global.gold += 5
		show_reward("+5 Gold")
	else:
		var potion = health_potion_scene.instantiate()
		potion.global_position = global_position + Vector2(0, -20)
		get_tree().current_scene.add_child(potion)
		show_reward("Health Potion!")

func show_reward(text_reward):
	$rewardlabel.text = text_reward
	$rewardlabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$rewardlabel.visible = false
