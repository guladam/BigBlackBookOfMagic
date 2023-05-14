extends Node2D


@onready var event_player: AnimationPlayer = $EventPlayer


func _ready() -> void:
	event_player.play_current_event()
	event_player.animation_finished.connect(_on_event_player_event_finished)


func _on_event_player_event_finished(_name: StringName) -> void:
	if event_player.current_event >= event_player.events:
		print("win if enemies die!")
	else:
		event_player.play_current_event()
