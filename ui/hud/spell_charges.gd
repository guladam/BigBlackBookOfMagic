extends Label

@export var spell_book: SpellBook

func _ready() -> void:
	if spell_book:
		spell_book.spell_charge_used.connect(_on_spell_charge_used)


func _on_spell_charge_used(charges_left: int) -> void:
	if charges_left > 0:
		text = "%s charges left" % charges_left
	else:
		text = "no active spell"
