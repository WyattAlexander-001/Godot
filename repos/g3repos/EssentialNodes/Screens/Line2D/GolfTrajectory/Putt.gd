extends RigidBody2D

export var max_launch_power := 600.0
export var max_line_width := 30.0

onready var _line: Line2D = $PuttLine2D
onready var _trajectory: Line2D = $Trajectory


func _ready() -> void:
	set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pull_object"):
		set_process(true)
	elif event.is_action_released("pull_object"):
		hit_putt(_trajectory.points[1])
		set_process(false)
		# Reset the points of our line, to hide them when the click is released.
		_line.points[1] = Vector2.ZERO
		_trajectory.points[1] = Vector2.ZERO


func _process(_delta: float) -> void:
	var launch_force := get_local_mouse_position()
	var launch_power := launch_force.length()
	var launch_direction := launch_force.normalized()

	# We limit the force to prevent the player from drawing long lines and
	# sending the ball at absurd speeds.
	if launch_power > max_launch_power:
		launch_force = launch_direction * max_launch_power
		launch_power = max_launch_power

	# We turn the distance our mouse is from the player into a proportional
	# width indicating hit strength.
	_line.width = range_lerp(launch_power, 0.0, max_launch_power, 0.0, max_line_width)
	# We draw the hitting line from the mouse to the ball, limiting its length.
	_line.points[1] = launch_force
	# We draw the trajectory line, this caches how far we want to fire the
	# asteroid for later.
	_trajectory.points[1] = -launch_direction * pow(launch_power, 1.2)


func hit_putt(trajectory: Vector2) -> void:
	apply_central_impulse(trajectory.rotated(global_rotation))
