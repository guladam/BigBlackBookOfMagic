extends "res://spells/spell.gd"

@export_range(0.0, 3.0) var time_between_zaps := 0.1
@export_range(1, 10) var zaps := 3
@onready var zap := preload("res://spells/zap/lightning.tscn")


func cast_towards(target: Vector2) -> void:
	var source := global_position
	for z in range(zaps):
		var new_zap = zap.instantiate()
		get_tree().root.add_child(new_zap)
		new_zap.create(source, target)
		await get_tree().create_timer(time_between_zaps).timeout


func destroy_spell() -> void:
	queue_free()
