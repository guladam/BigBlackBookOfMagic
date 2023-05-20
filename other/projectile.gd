class_name Projectile
extends Sprite2D

@export var speed := 1000.0
@export var lifetime := 3.0

var direction := Vector2.ZERO

@onready var timer := $Timer
@onready var hitbox := $HitBox
@onready var impact_detector := $ImpactDetector


func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	timer.timeout.connect(_on_impact.bind(null))
	timer.start(lifetime)
	impact_detector.body_entered.connect(_on_impact)
	impact_detector.area_entered.connect(_on_impact)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_impact(_body: Node) -> void:
	queue_free()
