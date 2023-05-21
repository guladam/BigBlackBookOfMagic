extends TileMap

signal castle_destroyed

@export var shake_cam: ShakingCamera2D
@export var game_stats: GameStats = preload("res://resources/game_stats.tres")
@onready var hurt_box: Area2D = $HurtBox
@onready var health: Health = $Health


func _ready() -> void:
	hurt_box.owner = self
	health.health = round(health.max_health * game_stats.castle_hp)


func take_damage(damage: int) -> void:
	health.health -= damage
	game_stats.castle_hp = health.health / float(health.max_health)
	
	if health.health <= 0:
		castle_destroyed.emit()
		queue_free()
		# TODO play some animation / sound?
		# or just prevent from emitting the signal again
	# TODO Maybe just on every 20% lost?
	elif shake_cam:
		shake_cam.add_trauma(0.25)
