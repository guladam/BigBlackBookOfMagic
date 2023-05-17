extends TileMap

signal castle_destroyed

@export var shake_cam: ShakingCamera2D

@onready var hurt_box: Area2D = $HurtBox
@onready var health: Node = $Health


func _ready() -> void:
	hurt_box.owner = self


func take_damage(damage: float) -> void:
	health.health -= damage
	if health.health <= 0:
		castle_destroyed.emit()
		queue_free()
		# TODO play some animation / sound?
		# or just prevent from emitting the signal again
	# TODO Maybe just on every 20% lost?
	elif shake_cam:
		shake_cam.add_trauma(0.25)
