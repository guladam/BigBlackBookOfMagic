var name
var points
var radians
var vector

func _init(m_name, m_points):
	name = m_name
	points = UnistrokeHelpers.resample(m_points, 128)
	radians = UnistrokeHelpers.indicative_angle(points)
	points = UnistrokeHelpers.scale_to(points, 250.0)
	points = UnistrokeHelpers.translate_to(points, Vector2.ZERO)
	vector = UnistrokeHelpers.vectorize(points)
