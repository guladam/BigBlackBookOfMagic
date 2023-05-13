extends CharacterBody2D


@export var speed = 300.0
@export var gravity: int = 10

@onready var sprite := $Sprite2D
@onready var anim := $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	play_animation()
	move_and_slide()


func play_animation() -> void:
	if velocity.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")
