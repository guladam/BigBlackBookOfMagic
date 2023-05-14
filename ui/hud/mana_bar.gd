extends ProgressBar

@export var player_mana: Mana

func _ready() -> void:
	if player_mana:
		player_mana.mana_changed.connect(_on_player_mana_changed)


func _on_player_mana_changed(new_mana: int, max_mana: int) -> void:
	value = new_mana / float(max_mana) * 100
