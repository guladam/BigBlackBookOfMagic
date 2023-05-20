extends "res://spells/spell.gd"

@onready var missile := preload("res://spells/magic_arrow/magic_missile.tscn")


func cast_towards(target: Vector2) -> void:
	var new_missile = missile.instantiate()
	new_missile.global_position = global_position
	new_missile.direction = global_position.direction_to(target)
	get_tree().root.add_child(new_missile)


func destroy_spell() -> void:
	queue_free()
