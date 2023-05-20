extends Projectile

@export var slow_percent := 0.5
@onready var explosion := preload("res://spells/ice_bolt/ice_explosion.tscn")

var already_impacted := false

func _on_impact(body: Node):
	if already_impacted:
		return
	
	if body and body.has_method("freeze"):
		body.freeze(slow_percent, 3.0)
	
	already_impacted = true	
	var exp_effect := explosion.instantiate()
	exp_effect.global_position = global_position
	get_tree().root.add_child(exp_effect)
	queue_free()
