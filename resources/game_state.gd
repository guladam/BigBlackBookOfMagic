extends Resource
class_name GameState

signal game_state_changed(state)

enum STATES {
	PLAYING,
	SPELL_DRAWING,
	PAUSED,
	UPGRADE_SELECTION
}

@export var state: STATES

func change_state(new_state: STATES) -> void:
	state = new_state
	game_state_changed.emit(state)
