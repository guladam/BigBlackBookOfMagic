extends Projectile

@onready var hit_effect := preload("res://enemies/ghost/ghost_fire_bolt_hit.tscn")


func _on_impact(_body: Node):
	var hit := hit_effect.instantiate()
	hit.global_position = global_position
	get_tree().root.add_child(hit)
	queue_free()
