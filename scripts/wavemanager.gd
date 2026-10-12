extends Node2D

@onready var portal = $"../portal"
@export var goblin_scene : PackedScene
@onready var enemies: Label = $"../CanvasLayer/enemies"
@onready var waves: Label = $"../CanvasLayer/waves"
var first_wave = true
var current_wave = 0
var enemies_alive = 0
var started = false
func _ready():

	waves.hide()
	enemies.hide()
	portal.get_node("AnimatedSprite2D").play("closed")
	portal.get_node("Area2D").monitoring = false
func start_next_wave():

	if current_wave >= 3:
		waves.text = "Wave 3 Complete!"

		portal.get_node("AnimatedSprite2D").play("open")
		portal.get_node("Area2D").monitoring = true
		await get_tree().create_timer(3).timeout
		waves.hide()
		return
	await countdown_before_wave()
	current_wave += 1
	update_enemy_counter()
	match current_wave:
		1:
			spawn_wave(3)
		2:
			spawn_wave(5)
		3:
			spawn_wave(7)
func spawn_wave(amount):

	enemies_alive = amount
	enemies.show()
	update_enemy_counter()
	var spawn_points = [
		$spawnpoint1,
		$spawnpoint2,
		$spawnpoint3
	]
	for i in range(amount):

		var goblin = goblin_scene.instantiate()

		var spawn = spawn_points[i % spawn_points.size()]
		var random_x = randf_range(-150, 150)
		goblin.global_position = spawn.global_position + Vector2(random_x, 0)

		get_tree().current_scene.add_child(goblin)

		goblin.enemy_died.connect(_on_enemy_died)
func _on_enemy_died():
	enemies_alive -= 1
	update_enemy_counter()
	if enemies_alive <= 0:
		waves.text = "Wave Complete!"
		enemies.hide()
		if current_wave >= 3:
			waves.text = "Wave 3 Complete!"
			portal.get_node("AnimatedSprite2D").play("open")
			portal.get_node("Area2D").monitoring = true
			await get_tree().create_timer(3).timeout
			
			waves.hide()
			return
		await get_tree().create_timer(2).timeout
		start_next_wave()
func update_enemy_counter():
	enemies.text = "Enemies Left: " + str(enemies_alive)
	waves.text = "Wave: " + str(current_wave)
func countdown_before_wave():
	waves.show()
	if first_wave:
		for i in range(3, 0, -1):
			waves.text = "Wave Starting In " + str(i)
			await get_tree().create_timer(1).timeout
		first_wave = false
	else:
		for i in range(3, 0, -1):
			waves.text = "Next Wave Starts In " + str(i)
			await get_tree().create_timer(1).timeout
