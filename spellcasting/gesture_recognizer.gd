extends Control

signal shape_detected(gesture, ink_left)

@export var input_action := ""
# set this to the max line length the user can draw
@export var max_ink := 0.7
# set to 0 in order to disable replenishing ink altogether
@export var ink_replenish_speed := 11.5 
# set to 0 in order to disable tracking ink altogether
@export var ink_loss_rate := 1 
@export var recording := true
@export var draw_particle: CPUParticles2D
@export var debug: DebugGUI
@export var progress: ProgressBar
@export var create_collisions := true
@export var max_drawn_col_shapes := 3

@onready var gestures_file := "res://spellcasting/gestures.save"
@onready var current_ink := max_ink
@onready var line := $Line2D

var pressed = false
var recognizer  = preload("res://spellcasting/recognizer.gd").new()
var unistroke  = preload("res://spellcasting/unistroke.gd")
var drawing = []
var current_position = Vector2.ZERO

var custom_cursor = preload("res://spellcasting/pencil.png")
var can_draw = false

var particleNode = null
var particleMaterial = null

var max_rec_points = 1000
var min_rec_points = 4

var saved_gestures = []
var data = {}

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	load_saved_gestures(gestures_file)
	
	# add debug dev gui if in dev mode
	if recording:
		debug.add_gesture.pressed.connect(_on_add_gesture_pressed)
		debug.save_gesture.pressed.connect(save_gestures)
		debug.status.set_text("Loaded %s recognizer from disk" % recognizer.unistrokes.size())
		get_tree().set_debug_collisions_hint(true)

	set_process_input(true)
	
	if ink_loss_rate > 0:
		set_process(true)
	
	update_gesture()


func _process(delta):
	if not InputMap.has_action(input_action):
		return
	
	# on release
	if not Input.is_action_pressed(input_action) and not pressed and can_draw:
		if current_ink <= max_ink and ink_replenish_speed != 0:
			current_ink += ink_replenish_speed * delta / 10
		else:
			current_ink = max_ink
	# on press
	elif current_ink > 0:
		current_ink -= ink_loss_rate * delta
	
	if current_ink < max_ink: 
		update_gesture()
	
	if current_ink < 0:
		current_ink = 0


func _input(event):	
	if not visible or not InputMap.has_action(input_action):
		return

	# on first press
	if event.is_action_pressed(input_action):
		start_drawing(event)
	
	# while pressed
	if event is InputEventMouseMotion and pressed:
		# if recording is complete or we ran out of ink
		# recognize the shape and return
		if drawing.size() > max_rec_points or current_ink <= 0:
			recognize_drawn_gesture()
			draw_particle.set_emitting(false)
			return
		
		current_position = get_local_mouse_position()
		drawing.append(current_position)
		
		# move particles
		if draw_particle:
			draw_particle.set_position(current_position)
			
		# update the drawing at every second point
		if drawing.size() % 2:
			update_gesture()
			
		if ink_loss_rate == 0:
			current_ink -= 0.01
	
	# on release
	if event.is_action_released(input_action):
		pressed = event.pressed
		
		if drawing.size() > min_rec_points and drawing.size() < max_rec_points:
			recognize_drawn_gesture()


func update_gesture():
	if drawing.size() <= 0 or not line:
		return
	
	line.points = drawing

	if ink_loss_rate <= 0 or not progress:
		return
	
	progress.value = current_ink / max_ink * 100


func _on_mouse_entered():
	can_draw = true
	Input.set_custom_mouse_cursor(custom_cursor)


func _on_mouse_exited():
	can_draw = false
	Input.set_custom_mouse_cursor(null)


func _on_add_gesture_pressed():
	if drawing.size() < min_rec_points or drawing.size() > max_rec_points:
		return
		
	var new_gesture = unistroke.new(debug.gesture_name.get_text(), drawing)
	recognizer.unistrokes.append(new_gesture)	
	
	# store to array that will be written to the json file
	saved_gestures.append([debug.gesture_name.get_text(), var_to_str(drawing)])
	
	if recording:
		print("we have %s recognizer so far" % saved_gestures.size())
		var status_text = "added drawing: %s uni: %s to ram"
		debug.status.set_text(status_text % [drawing.size(), recognizer.unistrokes.size()])
		
	drawing = []


func start_drawing(event: InputEvent) -> void:
	current_ink = max_ink
	drawing = []
	pressed = event.pressed
	current_position = get_local_mouse_position()
		
	if draw_particle and drawing.size() < max_rec_points:
		draw_particle.set_emitting(true)
		draw_particle.set_position(current_position)


func recognize_drawn_gesture():
	if draw_particle:
		draw_particle.set_position(current_position)
		draw_particle.set_emitting(false)
	
	if drawing.size() > max_rec_points: 
		return
	if drawing.size() == 0: 
		return
	
	var gesture = recognizer.recognize(drawing)
	var ink_left  = current_ink
	shape_detected.emit(gesture[0], gesture[1])
	
	if recording and debug.status:
		var msg := "%s, --ink left: %s --drawing: %s --gesture lib: %s"
		debug.status.set_text(msg % [gesture, ink_left, drawing.size(), recognizer.unistrokes.size()])

	# TODO this keeps throwing errors
	#draw_collision_shape(drawing)
	
	if ink_loss_rate == 0:
		current_ink = max_ink
		
	update_gesture()
	
	if not recording:
		drawing = []
		line.points = []
		hide()
		
	can_draw =  false


func save_gestures():
	data = {}
	
	var file = FileAccess.open(gestures_file, FileAccess.WRITE)
	data["recognizer"] = saved_gestures
	file.store_var(data, true)
	file.close()
	
	if recording:
		print("saved %s recognizer" % saved_gestures.size())


func load_saved_gestures(path):
	if recording:
		print("loading recognizer from:", path)
	
	var file = FileAccess.open(gestures_file, FileAccess.READ)
	
	# if the file is empty there's nothing to load
	if not file or file.get_length() == 0:
		return

	data = file.get_var(true)
	
	for gesture in data["recognizer"]:
		var gesture_points = []
		for point in str_to_var(gesture[1]):
			gesture_points.append(point)
		saved_gestures.append(gesture)
		
		recognizer.unistrokes.append(unistroke.new(gesture[0], gesture_points))
	
	if recording:
		print ("Loaded %s recognizer!" % saved_gestures.size())


func draw_collision_shape(points: Array):
	if current_ink <= 0 or not create_collisions:
		return
	
	if Geometry2D.triangulate_polygon(points).is_empty():
		return
		
	var col_poly = CollisionPolygon2D.new()
	col_poly.set_polygon(points)
	col_poly.add_to_group("drawn_shape:%s" % recognizer.recognize(drawing)[0])
	col_poly.add_to_group("drawn_shapes")
	add_child(col_poly)
	
	var drawn_col_shapes := get_tree().get_nodes_in_group("drawn_shapes")
	if max_drawn_col_shapes > 0 and drawn_col_shapes.size() > max_drawn_col_shapes:
		drawn_col_shapes[0].queue_free()
