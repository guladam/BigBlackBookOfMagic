extends Control

@export var indicator: PackedScene
@export var camera: Camera2D
@export var margin: Vector2

@onready var viewport_size := get_viewport_rect().size
@onready var viewport_center := self.viewport_size / 2

# Done according to this:
# https://gamedevelopment.tutsplus.com/tutorials/positioning-on-screen-indicators-to-point-to-off-screen-targets--gamedev-6644
func show_indicator(enemy: Node2D) -> void:
	var slope: float
	var enemy_offset: Vector2
	var indicator_pos: Vector2
	var center: Vector2
	var visible_rect: Rect2
	
	# grab the center of the screen and the visibility rect
	center = camera.get_screen_center_position()
	visible_rect = Rect2(center - viewport_size / 2, viewport_size)

	# if we see the enemy, no indicator is needed
	if visible_rect.has_point(enemy.global_position):
		return

	# else calculate the indicator's position and spawn it
	enemy_offset = enemy.global_position - center
	slope = enemy_offset.y / enemy_offset.x

	# top / bottom
	indicator_pos = Vector2.ZERO
	indicator_pos.x = sign(enemy_offset.y) * viewport_size.y / 2 / slope
	indicator_pos.y = sign(enemy_offset.y) * viewport_size.y / 2
	
	# left
	if indicator_pos.x < -viewport_size.x / 2:
		indicator_pos.x = -viewport_size.x / 2
		indicator_pos.y = slope * -viewport_size.x / 2
	# right
	elif indicator_pos.x > viewport_size.x / 2:
		indicator_pos.x = viewport_size.x / 2
		indicator_pos.y = slope * viewport_size.x / 2
	
	# apply margin
	indicator_pos.x -= margin.x * sign(enemy_offset.x)
	indicator_pos.y -= margin.y * sign(enemy_offset.y)
	
	# shift back to screen space
	indicator_pos += viewport_size / 2
	
	# instantiate indicator
	var new_indicator = indicator.instantiate()
	add_child(new_indicator)
	new_indicator.position = indicator_pos
