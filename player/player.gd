extends CharacterBody2D

@export var speed = 300.0
@export var gravity: int = 10
@export_range(0.0, 1.0) var spell_similarity_threshold := 0.8
@export var game_state: GameState
@export var game_stats: GameStats = preload("res://resources/game_stats.tres")

@onready var sprite := $Sprite2D
@onready var anim := $AnimationPlayer
@onready var spell_book: SpellBook = $SpellBook
@onready var aim: Node2D = $Aim


func _ready() -> void:
	game_state.game_state_changed.connect(_on_game_state_changed)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func _physics_process(delta: float) -> void:
	if not can_act():
		return
	
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
		spell_book.position.x *= -1 if sign(spell_book.position.x) != sign(velocity.x) else 1
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	play_animation()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not can_act():
		return

	if event.is_action_pressed("cast_spell"):
		spell_book.cast_spell(aim.get_current_aim())


func _on_spell_drawn(spell_name: String, similarity: float) -> void:
	if spell_name.ends_with("_alt"):
		spell_name = spell_name.get_slice("_alt", 0)
		
	if not game_stats.learned_spells.has(spell_name):
		return
	
	if similarity >= spell_similarity_threshold:
		var new_spell: Spell = spell_book.change_to_spell(spell_name)
		if new_spell.cast_range > 0:
			aim.change_crosshair_range(new_spell.cast_range)
			aim.show()
		else:
			aim.hide()


func _on_game_state_changed(new_state: GameState.STATES) -> void:
	aim.visible = new_state == GameState.STATES.PLAYING
	if new_state == GameState.STATES.PLAYING:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func can_act() -> bool:
	return game_state and game_state.state == GameState.STATES.PLAYING


func play_animation() -> void:
	if velocity.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")
