extends Node2D

@export var smoothing := 50
@onready var crosshair: Sprite2D = $Crosshair
var angle = 0.0

func _process(delta: float) -> void:
	angle = get_parent().get_local_mouse_position().normalized().angle() + PI / 2
	rotation = lerp_angle(rotation, angle, smoothing * delta)


func get_current_aim() -> Vector2:
	return crosshair.global_position


func change_crosshair_range(new_range: float) -> void:
	crosshair.position.y = -new_range
	
