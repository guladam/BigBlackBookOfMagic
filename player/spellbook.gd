extends Node2D
class_name SpellBook

# TODO menő resource loading pluginnal
const SPELLS = {
	"zap": preload("res://spells/zap/zap.tscn")
}

func change_to_spell(new_spell: String) -> Spell:
	for c in get_children():
		c.queue_free()
	
	if not SPELLS.has(new_spell):
		print("spell not found!")
		return
		
	var spell = SPELLS[new_spell].instantiate()
	add_child(spell)
	return spell


func cast_spell(target: Vector2) -> void:
	if get_child_count() == 0:
		return
	
	var spell: Spell = get_child(0)
	if not spell:
		return
	
	spell.cast_towards(target)
