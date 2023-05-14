extends Node

signal health_changed

@export var health := 1 : set = set_health

func set_health(new_health) -> void:
	health = new_health
	emit_signal("health_changed")
