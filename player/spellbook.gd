extends Node2D
class_name SpellBook

signal spell_charge_used(charges_left: int)

# TODO menő resource loading pluginnal
const SPELLS = {
	"magic_arrow": preload("res://spells/magic_arrow/magic_arrow.tscn"),
	"fireball": preload("res://spells/fireball/fireball.tscn"),
	"ice_bolt": preload("res://spells/ice_bolt/ice_bolt.tscn"),
	"zap": preload("res://spells/zap/zap.tscn"),
}


func change_to_spell(new_spell: String) -> Spell:
	for c in get_children():
		c.queue_free()
	
	if not SPELLS.has(new_spell):
		print("spell not found!")
		return
		
	var spell: Spell = SPELLS[new_spell].instantiate()
	add_child(spell)
	spell.charge_used.connect(func(charges_left): spell_charge_used.emit(charges_left))
	spell_charge_used.emit(spell.charges)
	
	return spell


func cast_spell(target: Vector2) -> void:
	if get_child_count() == 0:
		return
	
	var spell: Spell = get_child(0)
	if not spell:
		return
	
	if spell.charges <= 0:
		return
	
	spell.charges -= 1
	if spell.cast_range > 0:
		spell.cast_towards(target)
	else:
		spell.cast()
