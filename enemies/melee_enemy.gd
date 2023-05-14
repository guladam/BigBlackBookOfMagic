extends Area2D

@export var speed := 200
@export var attack_cooldown_seconds := 1.5

@onready var health := $Health
@onready var anim := $AnimationPlayer
@onready var attack_cooldown := $AttackCooldown

var target := Vector2.ZERO
var velocity: Vector2

func _ready() -> void:
	attack_cooldown.wait_time = attack_cooldown_seconds


func _process(delta: float) -> void:
	if target == Vector2.ZERO:
		return
	
	position += velocity * delta


func start_attacking(_target: Vector2) -> void:
	target = _target
	var dir: Vector2 = (target - global_position).normalized()
	#rotation = dir.angle()
	velocity = dir * speed
	anim.play("walk")


func take_damage(damage: int) -> void:
	health.health -= damage
	if health.health <= 0:
		queue_free()


func _on_attack_cooldown_timeout() -> void:
	anim.play("attack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		attack_cooldown.start()
		anim.play("idle")


func _on_attack_range_area_entered(_area: Area2D) -> void:
	anim.play("attack")
	target = Vector2.ZERO
