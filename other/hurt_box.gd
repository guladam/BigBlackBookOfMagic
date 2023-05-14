class_name HurtBox
extends Area2D

@export var damaged_by: HitBox.HITBOX_TYPE

func _init() -> void:
	monitorable = false


func _ready() -> void:
	match damaged_by:
		HitBox.HITBOX_TYPE.PLAYER:
			collision_mask = 4
		HitBox.HITBOX_TYPE.ENEMIES:
			collision_mask = 8
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitBox) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
