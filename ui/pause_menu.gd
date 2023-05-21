extends CanvasLayer

@export var game_state: GameState
@export var game_stats: GameStats

@onready var main_menu := "res://ui/main_menu.tscn"
@onready var spell_card := preload("res://ui/spell_card.tscn")
@onready var spell_cards: HBoxContainer = %SpellCards

var prev_state: GameState.STATES


func _ready() -> void:
	for upgrade in game_stats.upgrades:
		if upgrade.type == Upgrade.TYPE.SPELL:
			var new_card = spell_card.instantiate()
			new_card.upgrade = upgrade
			spell_cards.add_child(new_card)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()
		get_viewport().set_input_as_handled()


func pause() -> void:
	prev_state = game_state.state
	game_state.change_state(GameState.STATES.PAUSED)
	get_tree().paused = true
	show()


func unpause() -> void:
	game_state.change_state(prev_state)
	get_tree().paused = false
	hide()


func _on_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)
