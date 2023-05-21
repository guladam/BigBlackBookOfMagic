extends Marker2D

signal spawned(entity)

@export var spread: Vector2 = Vector2.ZERO
@export var target_random_offset: Vector2 = Vector2.ZERO
@export var spawn_scenes: Array[PackedScene]
@export var target: Marker2D


func spawn() -> Node:
	var target_offset = Vector2.ZERO
	if target_random_offset != Vector2.ZERO:
		target_offset.x = randf_range(-target_random_offset.x, target_random_offset.x)
		target_offset.y = randf_range(-target_random_offset.y, target_random_offset.y)
	
	var entity = spawn_scenes.pick_random().instantiate()
	add_child(entity)
	
	entity.set_as_top_level(true)
	entity.global_position = global_position
	entity.start_attacking(target.global_position + target_offset)
	
	emit_signal("spawned", entity)
	return entity
