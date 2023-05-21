extends Resource
class_name Upgrade

enum TYPE {SPELL, CASTLE_HEAL, PLAYER_STAT}

@export var base_img: Texture
@export var hover_img: Texture

@export var type: TYPE
@export var upgrade_name: String
@export_multiline var short_description: String

# TODO could be split into new classes w/ inheritance
@export var spell: PackedScene
@export var upgrade_number: float


func get_spell_name() -> String:
	return upgrade_name.replace(" ", "_").to_lower()
