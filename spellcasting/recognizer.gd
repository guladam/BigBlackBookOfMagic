var num_points = 128
var square_size = 250.0
var origin = Vector2(0,0)
var half_diagonal = 0.5 * sqrt(square_size * square_size + square_size * square_size)
var angle_range = deg_to_rad(45.0)
var angle_precision = deg_to_rad(2.0)
var phi = 0.5 * (-1.0 + sqrt(5.0))
var infinity = 88888888888888

var unistrokes = []
var unistroke = preload("res://spellcasting/unistroke.gd")

func recognize(points):
	points = UnistrokeHelpers.resample(points, num_points)
	points = UnistrokeHelpers.scale_to(points, square_size)
	points = UnistrokeHelpers.translate_to(points, origin)
	var b = infinity
	var u = -1
	for i in range(unistrokes.size()): # for each unistroke
		var d = distance_at_best_angle(points, unistrokes[i], -angle_range, angle_range, angle_precision)
		if (d < b):
			b = d # best (least) distance
			u = i # unistroke
	if u == -1:
		return ["no match", 0.0]
	else:
		return [unistrokes[u].name, 1.0 - b / half_diagonal]


func add_gesture(name, points):
	unistrokes.append(unistroke.new(name, points))


func distance_at_best_angle(points, T, a, b, threshold):
	var x1 = phi * a + (1.0 - phi) * b
	var f1 = distance_at_angle(points, T, x1)
	var x2 = (1.0 - phi) * a + phi * b
	var f2 = distance_at_angle(points, T, x2)
	while abs(b - a) > threshold:
		if f1 < f2:
			b = x2
			x2 = x1
			f2 = f1
			x1 = phi * a + (1.0 - phi) * b
			f1 = distance_at_angle(points, T, x1) 
		else:
			a = x1
			x1 = x2
			f1 = f2
			x2 = (1.0 - phi) * a + phi * b
			f2 = distance_at_angle(points, T, x2)
	return min(f1, f2)

func distance_at_angle(points, T, _radians):
	return UnistrokeHelpers.path_distance(points, T.points)
