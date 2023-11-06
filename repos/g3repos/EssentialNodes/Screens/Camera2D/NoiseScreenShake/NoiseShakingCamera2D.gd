extends Camera2D

# The maximum offset applied to the camera in pixels.
export var max_amplitude := 30.0

# We turn processing on and off through this property's setter function.
var shake_intensity := 0.0 setget set_shake_intensity

# We made our noise generator in the editor and saved it as a text resource
# file. This allows us to edit it in the Inspector while the game is running,
# with live reloading.
var _noise := preload("camera_noise.tres")


# We randomize the noise generator's seed to get a unique shake every time we
# play.
func _init() -> void:
	_noise.seed = randi()


func _physics_process(delta: float) -> void:
	# Every frame we lower the intensity while the effect is active.
	# When the intensity reaches zero, the setter turns off processing.
	set_shake_intensity(shake_intensity - delta)
	# We use the time value to move along the noise generator's axes.
	# Using time gives us a smooth and continuous effect.
	var time_elapsed := OS.get_ticks_msec() / 20.0
	# We calculate a direction by getting two values from the noise generator.
	var random_direction := Vector2(
		_noise.get_noise_2d(time_elapsed, time_elapsed * 3.0),
		_noise.get_noise_2d(time_elapsed * 2.0, time_elapsed)
	).normalized()
	# And we offset the camera's view.
	offset = random_direction * max_amplitude * shake_intensity * shake_intensity


func set_shake_intensity(intensity: float) -> void:
	shake_intensity = clamp(intensity, 0.0, 1.0)
	var is_shaking := not is_equal_approx(shake_intensity, 0.0)
	set_physics_process(is_shaking)


func _on_Mine_body_entered(body: Node) -> void:
	set_shake_intensity(1.0)
