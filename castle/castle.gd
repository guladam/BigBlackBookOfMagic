extends TileMap

@onready var hurt_box: Area2D = $HurtBox
@onready var health: Node = $Health


func _ready() -> void:
	hurt_box.owner = self


func take_damage(damage: float) -> void:
	health.health -= damage
	if health.health <= 0:
		print("lost")
		queue_free()
