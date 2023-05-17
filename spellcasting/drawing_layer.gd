extends CanvasLayer

@export var game_state: GameState
@export var shake_cam: ShakingCamera2D
@onready var gesture_recognizer: Control = $GestureRecognizer


func _input(event: InputEvent) -> void:
	if not gesture_recognizer.can_draw and event.is_action_pressed(gesture_recognizer.input_action):
		gesture_recognizer.can_draw = true
		gesture_recognizer.show()
		gesture_recognizer.start_drawing(event)
		game_state.change_state(GameState.STATES.SPELL_DRAWING)


func _on_gesture_recognizer_shape_detected(_gesture, matching: float) -> void:
	game_state.change_state(GameState.STATES.PLAYING)
	# TODO this should be a global setting because
	# the player uses it as well in the spellbook
	if matching < 0.75:
		shake_cam.add_trauma(0.75, true)
		# play sound
