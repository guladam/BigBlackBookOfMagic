extends Node

@export var fade_seconds := 1.2

@onready var players: Node = $Players

var _paused := false
var _play_from := 0.0
var _which_one_was_playing = -1
var _tweens: Array


func _ready() -> void:
	_tweens.resize(players.get_child_count())
	_tweens.fill(null)


func play_song_by_name(filename: String, single=true) -> void:
	var audio := load("res://music/" + filename)
	if audio:
		play_song(audio, single)

func play_song(music: AudioStream, single=true) -> void:
	if single:
		await stop()
	
	for player in players.get_children():
		if not player.playing:
			player.stream = music
			fade_in(player)
			player.play()
			break


func stop() -> void:
	for player in players.get_children():
		if player.get_index() < player.get_child_count() - 1:
			fade_out(player)
		else:
			await fade_out(player)


func pause() -> void:
	for player in players.get_children():
		if player.playing:
			_paused = true
			_play_from = player.get_playback_position()
			_which_one_was_playing = player.get_index()
			await fade_out(player)
			player.stop()
			break


func resume() -> void:
	if not _paused or _which_one_was_playing == -1:
		return
	
	var player = players.get_child(_which_one_was_playing)
	fade_in(player)
	player.play(_play_from)
	_paused = false
	_play_from = 0.0
	_which_one_was_playing = -1


func fade_out(player: AudioStreamPlayer) -> void:
	var idx := player.get_index()
	if _tweens[idx]:
		_tweens[idx].kill()
	
	var _t := create_tween().set_ease(Tween.EASE_IN)
	_tweens[idx] = _t
	_t.tween_property(player, "volume_db", -80.0, fade_seconds)
	_t.tween_callback(player.stop)
	await _t.finished


func fade_in(player: AudioStreamPlayer) -> void:
	var idx := player.get_index()
	if _tweens[idx]:
		_tweens[idx].kill()
	
	var _t := create_tween().set_ease(Tween.EASE_OUT)
	_tweens[idx] = _t
	_t.tween_property(player, "volume_db", 0.0, fade_seconds)
