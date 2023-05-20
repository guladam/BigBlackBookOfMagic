extends Projectile

@onready var explosion := preload("res://spells/fireball/explosion.tscn")
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D

var already_impacted := false

func _on_impact(_body: Node):
	if already_impacted:
		return
	
	already_impacted = true	
	var exp_effect := explosion.instantiate()
	collision_shape_2d.set_deferred("disabled", false)
	texture = null
	exp_effect.global_position = global_position
	get_tree().root.add_child(exp_effect)
	await get_tree().create_timer(0.1).timeout
	collision_shape_2d.set_deferred("disabled", true)
	queue_free()
