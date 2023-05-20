extends Area2D

signal died

@export var speed := 200
@export var attack_cooldown_seconds := 1.5

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: Area2D = $Sprite2D/HitBox
@onready var health := $Health
@onready var anim := $AnimationPlayer
@onready var attack_cooldown := $AttackCooldown
@onready var freeze_timer: Timer = $FreezeTimer

var target := Vector2.ZERO
var velocity: Vector2

var freeze_modifier := 1.0

func _ready() -> void:
	attack_cooldown.wait_time = attack_cooldown_seconds


func _process(delta: float) -> void:
	if target == Vector2.ZERO:
		return
	
	position += velocity * freeze_modifier * delta


func _on_attack_cooldown_timeout() -> void:
	anim.play("attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		attack_cooldown.start()
		anim.play("idle")


func _on_attack_range_body_entered(_body: Node2D) -> void:
	anim.play("attack")
	target = Vector2.ZERO


func start_attacking(_target: Vector2) -> void:
	target = _target
	var dir: Vector2 = (target - global_position).normalized()
	
	if dir.x < 0:
		sprite_2d.flip_h = true
		hit_box.position.x *= -1
	
	velocity = dir * speed
	anim.play("walk")


func take_damage(damage: int) -> void:
	health.health -= damage
	if health.health <= 0:
		died.emit()
		queue_free()


func freeze(slow_percent: float, time: float) -> void:
	freeze_timer.wait_time = time
	freeze_timer.start()
	
	# Freeze doesn't stack
	if freeze_modifier == 1.0:
		freeze_modifier = 1.0 - slow_percent
	
	sprite_2d.modulate = Color.AQUAMARINE


func unfreeze() -> void:
	freeze_modifier = 1.0	
	sprite_2d.modulate = Color.WHITE
