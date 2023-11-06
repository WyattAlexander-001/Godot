extends Spatial

## The duration of the laser beam's swipe animation in seconds.
const LASER_ANIMATION_DURATION := 0.4

# We use a random number generator to randomize the swipe animation, as well as
# the position of the laser outside the screen.
var _rng := RandomNumberGenerator.new()

onready var _path_follow: PathFollow = $PathShip/PathFollow
onready var _path_laser_curve: Curve3D = $PathLaser.curve
onready var _timer: Timer = $Timer
onready var _tween: Tween = $Tween
onready var _plop: Particles = $Plop


func _ready() -> void:
	_rng.randomize()
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")


func _on_Tween_tween_all_completed() -> void:
	_path_laser_curve.clear_points()
	_plop.emitting = false


func _on_Timer_timeout() -> void:
	var offset := _randv_hemisphere(50)
	for _i in range(2):
		_path_laser_curve.add_point(offset)


	_tween.stop_all()
	_tween.interpolate_method(
		self, "_animate_laser_swipe", _randv_hemisphere(1), _randv_hemisphere(1),
		LASER_ANIMATION_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	_tween.start()
	# Seeking forces the tween to update the animation state. Otherwise, the laser's position won't
	# update until the next frame, causing visual artifacts.
	_tween.seek(0.0)

	_timer.wait_time = _rng.randf_range(1, 2)
	_plop.emitting = true

func _animate_laser_swipe(offset: Vector3) -> void:
	var position := _path_follow.translation + offset
	_path_laser_curve.set_point_position(1, position)
	_plop.translation = position

func _randv_hemisphere(radius: int) -> Vector3:
	var v := Vector3.RIGHT.rotated(Vector3.DOWN, _rng.randf_range(0.0, PI))
	return radius * v.rotated(v.cross(Vector3.UP), _rng.randf_range(0.0, 0.5 * PI))
