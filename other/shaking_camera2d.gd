extends Camera2D
class_name ShakingCamera2D

# TODO global setting to turn it off
@export var decay := 1.5  # How quickly the shaking stops.
@export var max_offset := Vector2(25, 20)  # Maximum hor/ver shake in pixels.

@onready var noise: FastNoiseLite = FastNoiseLite.new()
var noise_y := 0.0
var trauma := 0.0  # Current shake strength.
var trauma_power := 2  # Trauma exponent. Use [2, 3].


func _ready():
	randomize()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.fractal_octaves = 3


func add_trauma(amount: float, ignore_previous := false):
	if trauma > 0 and not ignore_previous:
		return

	trauma = min(trauma + amount, 1.0)


func _process(delta: float):
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 0.5
	offset.x = max_offset.x * amount * noise.get_noise_2d(0.5, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(50, noise_y)
