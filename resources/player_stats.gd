extends Resource
class_name PlayerStats

signal spell_learned(spell_name: String)

@export var learned_spells: Array[String]
@export var spell_drawings: Dictionary
@export var spell_casts: Dictionary


func reset() -> void:
	learned_spells.clear()
	spell_drawings.clear()
	spell_casts.clear()


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
