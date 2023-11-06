tool
extends Path2D

## Emitted when the body detached from the zipline.
signal body_detached

## Speed at which the zipline moves in pixels per second.
const SPEED := 1600.0

# We use the following four properties to draw the zipline.
const CURVE_THICKNESS := 8.0
const CIRCLE_RADIUS := 10.0

export var curve_color := Color.white
export var circle_color := Color.white

onready var _path_follow: PathFollow2D = $PathFollow2D
onready var _remote_transform: RemoteTransform2D = $PathFollow2D/RemoteTransform2D
onready var _grab_area: Area2D = $PathFollow2D/GrabArea

## Direction in which the body should move along the zipline.
## We use it to know when we reached the desired end of the path.
var _direction: float


func _ready() -> void:
	# We use physics process to move the grabber and character along the path.
	# We only want processing on when a character is grabbing the zipline.
	set_physics_process(false)

## Draw the zipline with two circles on either end and a curve connecting them.
func _draw() -> void:
	var points := curve.get_baked_points()
	draw_polyline(points, curve_color, CURVE_THICKNESS)
	draw_circle(points[0], CIRCLE_RADIUS, circle_color)
	draw_circle(points[-1], CIRCLE_RADIUS, circle_color)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return

	# When the player presses "interact", we either detach the body from the zipline or we try to find and attach one using our Area2D.
	if is_physics_processing():
		detach_from_zipline()
	else:
		var bodies := _grab_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				attach_body_to_zipline(body)
				break


func _physics_process(delta: float) -> void:
	# Changing the PathFollow2D node's offset moves it along the parent Path2D
	# curve automatically.
	_path_follow.offset += delta * SPEED * _direction
	if did_reach_end():
		detach_from_zipline()

## Checks if the body reached the end of the zipline towards which it was moving.
func did_reach_end() -> bool:
	return (
		(_direction < 0.0 and is_zero_approx(_path_follow.unit_offset))
		or (_direction > 0.0 and is_equal_approx(_path_follow.unit_offset, 1.0))
	)


## Attaches a body to the zipline and starts moving it towards the end of the line.
func attach_body_to_zipline(body: KinematicBody2D) -> void:
	_remote_transform.remote_path = body.get_path()
	# This tells us in which direction the zipline should move and when it
	# reaches the end.
	_direction = body.get_look_direction()
	# We move the attached body in _physics_process().
	set_physics_process(true)
	# To make this work, we need the body to stop moving on its own. Here, we
	# achieve that by turning off its _physics_proccess().
	body.set_physics_process(false)
	if body.has_method("play_zipline_animation"):
		body.play_zipline_animation()
	# Finally, we connect our body_detached signal to turn physics process on again.
	#
	# The CONNECT_ONESHOT parameter will make sure this signal is disconnected when
	# we emit the signal. Otherwise it'd still be connected to previous used bodies.
	connect("body_detached", body, "set_physics_process", [true], CONNECT_ONESHOT)


## Detaches the currently attached body from the zipline.
func detach_from_zipline() -> void:
	_remote_transform.remote_path = ""
	set_physics_process(false)
	# With our signal connection in attach_body_to_zipline(), this triggers the
	# body's processing back on.
	emit_signal("body_detached")
