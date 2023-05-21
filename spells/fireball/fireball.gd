extends "res://spells/spell.gd"

@onready var projectile := preload("res://spells/fireball/fireball_projectile.tscn")


func cast_towards(target: Vector2) -> void:
	super.cast_towards(target)
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = global_position
	new_projectile.direction = global_position.direction_to(target)
	get_tree().root.add_child(new_projectile)


func destroy_spell() -> void:
	queue_free()
