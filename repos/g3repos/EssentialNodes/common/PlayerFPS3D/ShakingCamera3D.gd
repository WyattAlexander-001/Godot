extends Camera

# The maximum offset applied to the camera in units.
export var max_amplitude := 0.3

# We turn processing on and off through this property's setter function.
var shake_intensity := 0.0 setget set_shake_intensity

# We made our noise generator in the editor and saved it as a text resource
# file. This allows us to edit it in the Inspector while the game runs,
# with live reloading.
var _noise := preload("3d_camera_noise.tres")



# We randomize the noise generator's seed to get a unique shake every time we
# play.
func _init() -> void:
	_noise.seed = randi()


func _process(delta: float) -> void:
	# Every frame, we lower the intensity while the effect is active.
	# When the intensity reaches zero, the setter turns off processing.
	set_shake_intensity(shake_intensity - delta)
	# We use the time value to move along the noise generator's axes.
	# Using time gives us a smooth and continuous effect.
	var time_elapsed := OS.get_ticks_msec()
	# We calculate a direction by getting two values from the noise generator.
	var random_direction := Vector2(
		_noise.get_noise_2d(time_elapsed, 0),
		_noise.get_noise_2d(0, time_elapsed)
	).normalized()
	# And we apply the shake offset using the current intensity.
	var amplitude := max_amplitude * pow(shake_intensity, 2)
	# Those properties offset the camera's viewport rather than moving the node in the world.
	h_offset = random_direction.x * amplitude
	v_offset = random_direction.y * amplitude


func set_shake_intensity(intensity: float) -> void:
	shake_intensity = clamp(intensity, 0.0, 1.0)
	var is_shaking := not is_equal_approx(shake_intensity, 0.0)
	set_process(is_shaking)
