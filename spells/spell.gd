extends Sprite2D
class_name Spell

@export var cast_range := 150


func cast() -> void:
	pass


func cast_towards(_target: Vector2) -> void:
	pass

#TODO split this into targeted and untargeted spells
