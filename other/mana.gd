extends Node
class_name Mana

signal mana_changed(mana: int, max_mana: int)

@export var mana := 100.0 : set = set_mana
@export var mana_regen_per_second := 5.0

@onready var max_mana := mana


func _process(delta: float) -> void:
	mana += mana_regen_per_second * delta
	mana = clamp(mana, 0, max_mana)


func set_mana(new_mana) -> void:
	mana = new_mana
	mana_changed.emit(mana, max_mana)


func reset() -> void:
	self.set_mana(max_mana)
