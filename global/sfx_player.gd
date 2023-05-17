extends Node

@onready var players: Node = $Players

func play_by_name(filename: String) -> void:
	var audio := load("res://sound/" + filename)
	if audio:
		play(audio)


func play(sfx: AudioStream) -> void:
	if not sfx:
		return

	for player in players.get_children():
		if not player.playing:
			player.stream = sfx
			player.play()
			break
