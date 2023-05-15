extends Control

@export var indicator: PackedScene
@export var camera: Camera2D
@export var margin: Vector2

var visible_rect: Rect2
var viewport_center: Vector2
var center: Vector2
var max_offset: Vector2

func _ready() -> void:
	var viewport_size := get_viewport_rect().size
	viewport_center = viewport_size / 2
	max_offset = Vector2(viewport_size.x / 2, viewport_size.y / 2)


func show_indicator(enemy: Node2D) -> void:
	center = camera.get_screen_center_position()
	visible_rect = Rect2(center - max_offset, center + max_offset)

	if visible_rect.has_point(enemy.global_position):
		return

	var enemy_offset: Vector2 = (enemy.global_position - center).normalized()
	var indicator_pos: Vector2

	# TODO proper clamping and sticking
	indicator_pos = viewport_center + (enemy_offset * max_offset)
	
	
	var new_indicator = indicator.instantiate()
	add_child(new_indicator)
	new_indicator.position = indicator_pos
	print(indicator_pos)
