extends Node2D

var player_spawn_x: float = 59.00
var player_spawn_y: float = 702.00
var items = []
var collectedItems = []
var text_current = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_spawn_x  = 59.00
	player_spawn_y = 702.00


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
