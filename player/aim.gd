extends Node2D


@onready var crosshair: Sprite2D = $Crosshair
@onready var max_range := absf(self.crosshair.position.y)

var mouse: Vector2

func _process(_delta: float) -> void:
	mouse = get_parent().get_local_mouse_position()
	
	if mouse.length() > max_range:
		crosshair.position = mouse.normalized() * max_range
	else:
		crosshair.position = mouse


func get_current_aim() -> Vector2:
	return crosshair.global_position


func change_crosshair_range(new_range: float) -> void:
	max_range = new_range
	
