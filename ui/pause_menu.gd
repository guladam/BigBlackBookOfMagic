extends CanvasLayer

@export var game_state: GameState
@onready var main_menu := "res://ui/main_menu.tscn"

var prev_state: GameState.STATES


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
