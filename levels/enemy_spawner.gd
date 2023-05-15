extends Node

signal spawned(entity)

@onready var spawn_points: Array[Node] = self.get_children()
var last_spawn_point


func _ready() -> void:
	randomize()
	
	for spawn_point in spawn_points:
		spawn_point.spawned.connect(func(entity): spawned.emit(entity))


func spawn_random() -> void:
	var new_point = spawn_points.pick_random()
	while new_point == last_spawn_point:
		new_point = spawn_points.pick_random()
	
	new_point.spawn()
	
	last_spawn_point = new_point


func spawn_everywhere() -> void:
	for spawn_point in spawn_points:
		spawn_point.spawn()
