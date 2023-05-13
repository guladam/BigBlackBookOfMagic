var x
var y
var width
var height

func _init(m_x, m_y, m_width, m_height):
	x = m_x
	y = m_y
	width = m_width
	height = m_height
	if width == 0:
		width = 1
	if height == 0:
		height = 1
