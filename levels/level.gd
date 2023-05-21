extends Node2D

@export var level: int
@export var next_level: PackedScene
@export var available_upgrades: Array[Upgrade]
@export var game_state: GameState = preload("res://resources/game_state.tres")
@export var game_stats: GameStats = preload("res://resources/game_stats.tres")
@export var level_win_sound: AudioStream

@onready var event_player: AnimationPlayer = $EventPlayer
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var spell_learning_layer: CanvasLayer = $SpellLearningLayer
@onready var game_over: CanvasLayer = $GameOver
@onready var win_screen: CanvasLayer = $WinScreen
@onready var demon_growls := preload("res://sfx/demon_randomgrowls.ogg")

var check_for_win := false
var win_check_frequency := 2.0
var last_win_check := 0.0


func _ready() -> void:
	event_player.play_current_event()
	event_player.animation_finished.connect(_on_event_player_event_finished)
	MusicPlayer.play_song(demon_growls, false)
	
	for upgrade in available_upgrades:
		if upgrade.type == Upgrade.TYPE.SPELL and game_stats.learned_spells.has(upgrade.get_spell_name()):
			available_upgrades.erase(upgrade)
	available_upgrades.shuffle()


func _process(delta: float) -> void:
	if not check_for_win:
		return
		
	last_win_check += delta
	if last_win_check > win_check_frequency:
		check_for_level_win()
		last_win_check = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_state.state == GameState.STATES.PLAYING:
		pause_menu.pause()


func _on_event_player_event_finished(_name: StringName) -> void:
	if event_player.current_event < event_player.events:
		event_player.play_current_event()
	else:
		check_for_win = true


func _on_castle_castle_destroyed() -> void:
	game_over.show_screen()


func _on_upgrade_selected(upgrade: Upgrade) -> void:
	game_stats.upgrades.append(upgrade)
	
	match upgrade.type:
		Upgrade.TYPE.SPELL:
			game_stats.learn_spell(upgrade.get_spell_name())
		Upgrade.TYPE.CASTLE_HEAL:
			game_stats.castle_hp += upgrade.upgrade_number
	
	get_tree().change_scene_to_packed(next_level)


func check_for_level_win() -> void:
	if get_tree().get_nodes_in_group("enemies").size() <= 0:
		check_for_win = false
		
		if not next_level:
			win_screen.show_screen()
		else:
			spell_learning_layer.show_upgrades(available_upgrades)
			SfxPlayer.play(level_win_sound)
