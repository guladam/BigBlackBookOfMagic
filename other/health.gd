extends Node
class_name Health

signal health_changed(health: int, max_health: int)

@export var health := 1 : set = set_health
@onready var max_health := health


func set_health(new_health) -> void:
	health = new_health
	health_changed.emit(health, max_health)


func reset() -> void:
	self.set_health(max_health)
