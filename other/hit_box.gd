class_name HitBox
extends Area2D

@export var type: HITBOX_TYPE
@export var damage := 10

enum HITBOX_TYPE {
	PLAYER,
	ENEMIES
}

func _init() -> void:
	collision_mask = 17


func _ready() -> void:
	match type:
		HITBOX_TYPE.PLAYER:
			collision_layer = 4
		HITBOX_TYPE.ENEMIES:
			collision_layer = 8
