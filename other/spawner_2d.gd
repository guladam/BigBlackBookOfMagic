extends Marker2D

signal spawned(entity)

@export var spread: Vector2 = Vector2.ZERO
@export var spawn_scenes: Array[PackedScene]
@export var target: Marker2D


func spawn() -> Node:
	var entity = spawn_scenes.pick_random().instantiate()
	add_child(entity)
	
	entity.set_as_top_level(true)
	entity.global_position = global_position
	entity.start_attacking(target.global_position)
	
	emit_signal("spawned", entity)
	return entity
