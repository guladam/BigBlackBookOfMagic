extends ProgressBar

@export var castle_hp: Health

func _ready() -> void:
	if castle_hp:
		castle_hp.health_changed.connect(_on_castle_health_changed)
		_on_castle_health_changed(castle_hp.health, castle_hp.max_health)


func _on_castle_health_changed(new_hp: int, max_hp: int) -> void:
	value = new_hp / float(max_hp) * 100
