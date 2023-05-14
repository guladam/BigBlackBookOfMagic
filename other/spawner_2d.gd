extends Marker2D

signal spawned(entity)

@export var spread: Vector2 = Vector2.ZERO
@export var spawn_scene: PackedScene

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	var imp := spawn()
	imp.start_attacking($Castle.global_position)


func get_random_spread() -> Vector2:
	return Vector2(
		randf_range(-1 * spread.x, spread.x),
		randf_range(-1 * spread.y, spread.y)
	)

func spawn() -> Node:
	var entity = spawn_scene.instantiate()
	add_child(entity)
	
	entity.set_as_top_level(true)
	entity.global_position = global_position + get_random_spread()
	
	emit_signal("spawned", entity)
	return entity
