extends Resource
class_name PlayerStats

signal spell_learned(spell_name: String)

@export var learned_spells: Array[String]
@export var spell_drawings: Dictionary
@export var spell_casts: Dictionary
@export var castle_hp := 1.0
@export var castle_repairs := 0


func reset() -> void:
	learned_spells.clear()
	spell_drawings.clear()
	spell_casts.clear()
	castle_hp = 1.0
	castle_repairs = 0


func learn_spell(spell_name: String) -> void:
	learned_spells.append(spell_name)
	spell_learned.emit(spell_name)


func _on_spell_drawn(spell: Spell) -> void:
	dict_create_or_increment(spell_drawings, spell.spell_name)


func _on_spell_cast(spell: Spell) -> void:
	dict_create_or_increment(spell_casts, spell.spell_name)


func dict_create_or_increment(dict: Dictionary, key: String) -> void:
	if dict.has(key):
		dict[key] += 1
	else:
		dict[key] = 1
