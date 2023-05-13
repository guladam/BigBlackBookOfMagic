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
@export var particle_effect := true
@export var particle_color := Color(1, 1, 1, 1)
@onready var gesture_json_path =  "res://spellcasting/gestures.json"
@onready var current_ink = max_ink
@export var line_thickness = 2.0
@export var line_color = Color(255, 0, 0, 1)
@export var ink_healthbar_width = 100
@export var debug_text: Label
@export var debug_new_name: LineEdit
@export var create_collisions = true
@export var max_drawn_col_shapes = 3

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
	if input_action == "":
		print("TODO: warning message")

	# TODO replace this with a scene
	if particle_effect: ## set fancy particle effect if user wanted it
		pass
		
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	load_saved_gestures(gesture_json_path)
	
	# TODO create this scene and rework this part
	if recording: ## add debug dev gui if in dev mode
		#var debug_gui = preload("debug_gui.tscn").instance()
		#add_child(debug_gui)
		#debug_gui.set_position(Vector2(get_global_position().x,get_size().y))
		#get_node("gui/addGesture").connect("pressed",self,"_on_addGesture_pressed")
		#get_node("gui/saveGesturesToJson").connect("pressed",self,"saveGesturesToJsonFile")
		#get_node("gui/status").set_text(str("Loaded ",recognizer.unistrokes.size()," recognizer from json library"))
		#get_tree().set_debug_collisions_hint(true)
		pass
		
	set_process_input(true)
	
	if ink_loss_rate > 0:
		set_process(true)
	
	queue_redraw()


func _process(delta):
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
		queue_redraw()
	
	if current_ink < 0:
		current_ink = 0


func _input(event):	
	if not can_draw:
		return

	# on first press
	if event.is_action_pressed(input_action):
		drawing = []
		pressed = event.pressed
		current_position = get_local_mouse_position()
		
		if particle_effect and drawing.size() < max_rec_points:
			particleNode.set_emitting(true)
			particleNode.set_position(current_position)
	
	# while pressed
	if event is InputEventMouseMotion and pressed:
		# if recording is complete or we ran out of ink
		# recognize the shape and return
		if drawing.size() > max_rec_points or current_ink <= 0:
			recognize_drawn_gesture()
			particleNode.set_emitting(false)
			return
		
		current_position = get_local_mouse_position()
		drawing.append(current_position)
		
		# move particles
		if particle_effect:
			particleNode.set_position(current_position)
		# update the drawing at every second point
		if drawing.size() % 2:
			queue_redraw()
			
		if ink_loss_rate == 0:
			current_ink -= 0.01
	
	# on release
	if event.is_action_released(input_action):
		pressed = event.pressed
		
		if drawing.size() > min_rec_points and drawing.size() < max_rec_points:
			recognize_drawn_gesture()


func _draw():
	if drawing.size() <= 0:
		return

	if line_thickness <= 0:
		return

	if ink_loss_rate <= 0 or ink_healthbar_width <= 0:
		return
	
	if current_ink > 0 and ink_healthbar_width > 0:
		draw_rect(Rect2(10, 10, current_ink * ink_healthbar_width, 20), line_color)
		
	for i in range(1, len(drawing)):
		draw_line(drawing[i-1], drawing[i], Color(line_color.r, line_color.g, line_color.b, current_ink), line_thickness)


func _on_mouse_entered():
	can_draw = true
	Input.set_custom_mouse_cursor(custom_cursor)


func _on_mouse_exited():
	can_draw = false
	Input.set_custom_mouse_cursor(null)


func _on_add_gesture_pressed():
	if drawing.size() < min_rec_points or drawing.size() > max_rec_points:
		return
		
	var new_gesture = unistroke.new(debug_new_name.get_text(), drawing)
	recognizer.unistrokes.append(new_gesture)	
	
	# store to array that will be written to the json file
	saved_gestures.append([debug_new_name.get_text(), var_to_str(drawing)])
	
	if recording:
		print("we have %s recognizer so far" % saved_gestures.size())
		var status_text = "added drawing: %s uni: %s to ram"
		debug_text.set_text(status_text % [drawing.size(), recognizer.unistrokes.size()])
		
	drawing = []


func recognize_drawn_gesture():
	if particle_effect:
		particleNode.set_position(current_position)
		particleNode.set_emitting(false)
	
	if drawing.size() > max_rec_points: 
		return
	if drawing.size() == 0: 
		return
	
	var gesture = recognizer.recognize(drawing)
	var ink_left  = current_ink
	shape_detected.emit(gesture, ink_left)
	
	if recording and debug_text:
		var msg := "%s, --ink left: %s --drawing: %s --gesture lib: %s"
		debug_text.set_text(msg % [gesture, ink_left, drawing.size(), recognizer.unistrokes.size()])

	draw_collision_shape(drawing)
	
	if ink_loss_rate == 0:
		current_ink = max_ink
		
	queue_redraw()
	
	if not recording:
		drawing = []
	

func saveGesturesToJsonFile():
	data = {}
	var file = File.new()
	file.open(gestureJsonFilePath, File.WRITE)
	data["recognizer"] = savedGestures
	file.store_line(JSON.print(data))
	file.close()
	if recording:print("saved ",savedGestures.size()," recognizer")

var loadedGestures = []
func load_saved_gestures(path):
	if recording:print("loading recognizer from:",path)
	var file = File.new()
	file.open(gestureJsonFilePath, File.READ)
	var rawString = file.get_as_text()
	if rawString.length() == 0:return #nothing loaded, thus skip
	data = JSON.parse(rawString).result
	
	for gesture in data["recognizer"]:
		var cleanedGesture = []
		for vectorval in str2var(gesture[1]):
			cleanedGesture.append(vectorval)
		var cleanedGestureData = []
		cleanedGestureData.append(str(gesture[0]))
		cleanedGestureData.append(cleanedGesture)
		loadedGestures.append(cleanedGestureData)
		savedGestures.append(gesture)

	for loadGesture in loadedGestures:
		var newGesture = preload("unistroke.gd").new(loadGesture[0], loadGesture[1])
		recognizer.unistrokes.append(newGesture)
	if recording:print ("Loaded ",loadedGestures.size()," recognizer!")

### drawing a colision shape from the array ###
func draw_collision_shape(vector2arr):
	if current_ink > 0 and create_collisions:
		var colShapePol = CollisionPolygon2D.new()
		colShapePol.set_polygon(vector2arr)
		colShapePol.add_to_group(str("drawnShape:",recognizer.recognize(drawing))) ##will be useful later on for colisions
		colShapePol.add_to_group("drawnShapes") ## use to keep track of all
		add_child(colShapePol)
	### limit how many maximum drawn shapes can exist ### you can destroy them on collision elsewhere
	if max_drawn_col_shapes > 0:##if set to 0, it is disabled
		if get_tree().get_nodes_in_group("drawnShapes").size() > max_drawn_col_shapes:
			get_tree().get_nodes_in_group("drawnShapes")[0].queue_free()## remove the oldest
