extends CanvasLayer

@export var game_state: GameState = preload("res://resources/game_state.tres")
@export var sound: AudioStream


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func show_screen() -> void:
	game_state.change_state(GameState.STATES.PAUSED)
	get_tree().paused = true
	SfxPlayer.play(sound)
	show()
