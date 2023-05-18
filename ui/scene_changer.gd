extends CanvasLayer

@export_file("*.tscn") var target_scene: String
@export var fade_duration := 1.5

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 1.0
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	t.tween_callback(color_rect.hide)


func transition_to(_next_scene := target_scene) -> void:
	color_rect.show()
	var t := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	t.tween_callback(get_tree().change_scene_to_file.bind(_next_scene))
