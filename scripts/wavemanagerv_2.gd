extends Node2D

@export var flying_eye_scene : PackedScene
@export var boss_scene : PackedScene
@onready var enemies: Label = $"../CanvasLayer/enemies"
@onready var waves: Label = $"../CanvasLayer/waves"
@onready var next_level_portal: Area2D = $"../next_level_portal"

var first_wave = true
var current_wave = 0
var enemies_alive = 0
var started = false
func _ready():

	waves.hide()
	enemies.hide()
	next_level_portal.get_node("AnimatedSprite2D").play("closed")
	next_level_portal.monitoring = false
	$"../next_level_portal".visible = false
func start_next_wave():
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
		4:
			waves.text = "BOSS INCOMING!"
			spawn_boss()
func spawn_boss():
	print("SPAWNING BOSS")
	print($boss_spawn.global_position)
	print("Boss scene:", boss_scene)
	var boss = boss_scene.instantiate()
	boss.global_position = $boss_spawn.global_position
	get_tree().current_scene.add_child(boss)
	waves.text = "BOSS INCOMING!"
	waves.show()
	boss.enemy_died.connect(_on_boss_died)
func _on_boss_died():
	print("BOSS DEFEATED!")
	waves.show()
	next_level_portal.visible = true
	next_level_portal.get_node("AnimatedSprite2D").play("open")
	next_level_portal.monitoring = true
func spawn_wave(amount):
	enemies_alive = amount
	enemies.show()
	update_enemy_counter()
	var spawn_points = [
		$spawnpoint1,
		$spawnpoint2,
		$spawnpoint3,
		$boss_spawn
	]
	for i in range(amount):
		var eye = flying_eye_scene.instantiate()
		var spawn = spawn_points[i % spawn_points.size()]
		var random_x = randf_range(-150, 150)
		eye.global_position = spawn.global_position + Vector2(random_x, 0)
		get_tree().current_scene.add_child(eye)
		eye.enemy_died.connect(_on_enemy_died)
func _on_enemy_died():
	enemies_alive -= 1
	update_enemy_counter()
	if enemies_alive <= 0:
		waves.text = "Wave Complete!"
		enemies.hide()
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
func spawn_enemy(scene: PackedScene, amount):
	for i in range(amount):
		var enemy = scene.instantiate()
		var spawn
