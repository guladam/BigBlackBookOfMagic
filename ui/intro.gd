extends ColorRect


@onready var skip_button = $SkipButton
@onready var scene_changer = $SceneChanger

var intro_finished := false


func _input(event) -> void:
	if event.is_action_pressed("pause"):
		start_game()
	
	if not intro_finished:
		return

	if event.is_action_pressed("cast_spell") or event.is_action_pressed("ui_accept"):
		start_game()


func _on_intro_finished(_anim_name: String) -> void:
	skip_button.text = "Start"
	intro_finished = true


func start_game() -> void:
	scene_changer.transition_to()
