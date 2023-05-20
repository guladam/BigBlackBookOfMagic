extends Node2D

@export var next_level: PackedScene
@export var available_upgrades: Array[Upgrade]

@onready var event_player: AnimationPlayer = $EventPlayer
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var spell_learning_layer: CanvasLayer = $SpellLearningLayer

var check_for_win := false
var win_check_frequency := 2.0
var last_win_check := 0.0


func _ready() -> void:
	event_player.play_current_event()
	event_player.animation_finished.connect(_on_event_player_event_finished)
	available_upgrades.shuffle()
	spell_learning_layer.show_upgrades(available_upgrades)


func _process(delta: float) -> void:
	if not check_for_win:
		return
		
	last_win_check += delta
	if last_win_check > win_check_frequency:
		check_for_level_win()
		last_win_check = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.pause()


func _on_event_player_event_finished(_name: StringName) -> void:
	if event_player.current_event < event_player.events:
		event_player.play_current_event()
	else:
		check_for_win = true


func _on_castle_castle_destroyed() -> void:
	print("lost!")


func check_for_level_win() -> void:
	print(get_tree().get_nodes_in_group("enemies"))
	if get_tree().get_nodes_in_group("enemies").size() <= 0:
		print("won!")
		check_for_win = false
