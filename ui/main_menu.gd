extends Control

@onready var game_state: GameState = preload("res://resources/game_state.tres")
@onready var game_stats: GameStats = preload("res://resources/game_stats.tres")
@onready var scene_changer = $SceneChanger
@onready var screens := {
	"new_game": "res://ui/intro.tscn",
	"options": "res://ui/options.tscn",
	"credits": "res://ui/credits.tscn"
}

func _ready() -> void:
	game_state.change_state(GameState.STATES.PLAYING)
	game_stats.reset()


func _on_new_game_pressed() -> void:
	scene_changer.transition_to(screens["new_game"])


func _on_options_pressed() -> void:
	scene_changer.transition_to(screens["options"])


func _on_credits_pressed() -> void:
	scene_changer.transition_to(screens["credits"])


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_tutorial_toggled(button_pressed: bool) -> void:
	Global.tutorial = button_pressed
