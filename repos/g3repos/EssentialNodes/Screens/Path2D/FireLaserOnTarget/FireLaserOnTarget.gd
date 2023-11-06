extends Node2D

## The duration of the laser beam's swipe animation in seconds.
const LASER_ANIMATION_DURATION := 0.4

# We use a random number generator to randomize the angle of the swipe
# animation, as well as the position of the laser outside the screen.
var _rng := RandomNumberGenerator.new()

onready var _path_follow: PathFollow2D = $Path2DShip/PathFollow2D
onready var _path_laser_curve: Curve2D = $Path2DLaser.curve
onready var _laser: Line2D = $Laser
onready var _target: Line2D = $Target
onready var _tween: Tween = $Tween
onready var _timer: Timer = $Timer
onready var _plop: Particles2D = $Plop


func _ready() -> void:
	_rng.randomize()
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_tween.connect("tween_all_completed", _laser, "set_visible", [false])
	_laser.points = PoolVector2Array([Vector2.ZERO, Vector2.ZERO])
	_laser.visible = false


func _on_Timer_timeout() -> void:
	# Rotate `Target` randomly for some variation.
	_target.rotation = _rng.randf_range(0, PI / 2)

	# Get a random location off-sreen, on `Path2DLaser`. This is the origin point for
	# the incoming laser.
	_laser.points[0] = _path_laser_curve.interpolate_baked(
		_rng.randf_range(0, _path_laser_curve.get_baked_length())
	)

	# Since the target is controlled by a `RemoteTransform2D` and a `PathFollow2D`, we need to
	# convert its points in global coordinates.
	var target: PoolVector2Array = _target.transform.xform(_target.points)

	_tween.stop_all()
	_tween.interpolate_method(
		self, "_animate_laser_swipe", target[0], target[1], LASER_ANIMATION_DURATION,
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	_tween.start()
	# Seeking forces the tween to update the animation state. Otherwise, the laser's position won't
	# update until the next frame, causing visual artifacts.
	_tween.seek(0.0)
	_laser.visible = true

	# We wait for a random amount of time between one and two seconds before
	# firing again.
	_timer.wait_time = _rng.randf_range(1, 2)
	_plop.restart()


## Gets called on every `Tween` step. Since the origin of the laser is fixed, we swipe by
## changing the second point on the Line2D node.
func _animate_laser_swipe(point: Vector2) -> void:
	_laser.points[1] = point
	_plop.position = point
