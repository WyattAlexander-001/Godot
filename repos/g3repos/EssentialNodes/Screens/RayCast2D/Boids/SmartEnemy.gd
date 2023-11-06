extends RigidBody2D

var movement_force := 10000.0
var turn_force := 300000.0
var direction := Vector2.UP

onready var _line: Line2D = $Line2D
onready var _left_ray: RayCast2D = $RayCasts/LeftCast2D
onready var _right_ray: RayCast2D = $RayCasts/RightCast2D


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.apply_central_impulse(Vector2.UP.rotated(global_rotation) * movement_force * state.step)

	if _left_ray.is_colliding():
		var torque: float = calculate_collision_magnitude(_left_ray) * turn_force * state.step
		state.apply_torque_impulse(torque)
	elif _right_ray.is_colliding():
		var torque: float = calculate_collision_magnitude(_right_ray) * -turn_force * state.step
		state.apply_torque_impulse(torque)

	_line.points[1] = Vector2(state.angular_velocity * 40, 0)


## Returns a value between 0.0 and 1.0 representing how close the ship is to the wall.
func calculate_collision_magnitude(cast: RayCast2D) -> float:
	var max_length := cast.cast_to.length_squared()
	var collision_length := cast.to_local(cast.get_collision_point()).length_squared()
	return 1.0 - (collision_length / max_length)
