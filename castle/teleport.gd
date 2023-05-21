extends Area2D
class_name Teleport

@export var color: Color = Color.WHITE
@export var destination: Teleport
@export var game_state: GameState
@export var use_sfx: AudioStream

var _can_use := false
var _character: Node2D


func _ready() -> void:
	$Light.modulate = color


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item") and destination and _can_use and _character and game_state.state == GameState.STATES.PLAYING:
		# TODO animate this in a cool way,
		# maybe also use particle effects
		SfxPlayer.play(use_sfx)
		_character.global_position = destination.global_position


func _on_body_entered(body: Node2D) -> void:
	_can_use = true
	_character = body


func _on_body_exited(_body: Node2D) -> void:
	_can_use = false
	_character = null
