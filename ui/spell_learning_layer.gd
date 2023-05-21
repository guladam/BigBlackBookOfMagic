extends CanvasLayer

signal upgrade_selected(upgrade: Upgrade)

@export var game_state: GameState
@export var game_stats: GameStats = preload("res://resources/game_stats.tres")

@onready var description: Label = %Description
@onready var upgrade_name: Label = %UpgradeName
@onready var upgrade_card := preload("res://ui/upgrade.tscn")
@onready var upgrade_cards: HBoxContainer = %UpgradeCards
@onready var confirm: Button = %Confirm

var selected_upgrade: Upgrade = null


func show_upgrades(upgrades: Array[Upgrade]) -> void:
	game_state.change_state(GameState.STATES.UPGRADE_SELECTION)
	get_tree().paused = true
	
	for upgrade in upgrades:
		var new_upgrade := upgrade_card.instantiate()
		new_upgrade.upgrade = upgrade
		new_upgrade.hovered.connect(_on_upgrade_hovered)
		new_upgrade.mouse_exited.connect(_on_upgrade_mouse_exited)
		new_upgrade.selected.connect(_on_upgrade_selected)
		upgrade_cards.add_child(new_upgrade)

	show()


func _on_upgrade_hovered(upgrade: Upgrade) -> void:
	upgrade_name.text = upgrade.upgrade_name
	description.text = upgrade.short_description


func _on_upgrade_mouse_exited() -> void:
	upgrade_name.text = ""
	description.text = ""


func _on_upgrade_selected(upgrade: Upgrade) -> void:
	confirm.disabled = false
	selected_upgrade = upgrade


func _on_confirm_pressed() -> void:
	game_state.change_state(GameState.STATES.PLAYING)
	get_tree().paused = false
	upgrade_selected.emit(selected_upgrade)
	hide()
