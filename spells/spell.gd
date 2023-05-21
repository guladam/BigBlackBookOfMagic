extends Sprite2D
class_name Spell

signal charge_used(remaining_charges: int)

@export var sound: AudioStream
@export var spell_name: String
@export var cast_range := 150
@export var charges := 1 : set = _set_charges


func _set_charges(_charges: int) -> void:
	charges = _charges
	charge_used.emit(_charges)
	
	if _charges <= 0:
		destroy_spell()


func cast() -> void:
	SfxPlayer.play(sound)


func cast_towards(_target: Vector2) -> void:
	SfxPlayer.play(sound)


func destroy_spell() -> void:
	pass
