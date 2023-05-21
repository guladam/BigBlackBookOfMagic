extends MarginContainer

@export var spell_book: SpellBook
@onready var content: HBoxContainer = $MarginContainer/Content
@onready var spell_charge := preload("res://ui/hud/spell_charge.tscn")


func _ready() -> void:
	hide()

	if spell_book:
		spell_book.spell_charge_used.connect(_on_spell_charge_used)
		spell_book.spell_drawn.connect(_on_spell_drawn)


func _on_spell_drawn(spell: Spell) -> void:
	for c in content.get_children():
		c.queue_free()
		
	for i in range(spell.charges):
		var new_charge = spell_charge.instantiate()
		content.add_child(new_charge)
		
	show()


func _on_spell_charge_used(charges_left: int) -> void:
	if charges_left > 0:
		content.get_child(content.get_child_count() - 1).queue_free()
	else:
		hide()
