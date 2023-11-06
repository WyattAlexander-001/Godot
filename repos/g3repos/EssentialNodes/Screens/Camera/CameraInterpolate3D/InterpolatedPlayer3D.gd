extends Player3D


func change_camera_focus(target_global_transform: Transform) -> void:
	_camera_controller.set_focus_to(target_global_transform)


func reset_camera_focus() -> void:
	_camera_controller.reset_focus()


func reset_position() -> void:
	transform.origin = _start_position
	_camera_controller.reset_camera_position()


# We redifine this function so it uses the right node to get directions
func _get_camera_oriented_input() -> Vector3:
	var input_left_right := (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var input_forward_back := (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	var raw_input = Vector2(input_left_right, input_forward_back)

	var input := Vector3.ZERO
	# This is to ensure that diagonal input isn't stronger than axis aligned input
	input.x = raw_input.x * sqrt(1.0 - raw_input.y * raw_input.y / 2.0)
	input.z = raw_input.y * sqrt(1.0 - raw_input.x * raw_input.x / 2.0)

	input = _camera_controller.get_camera_global_transform().basis.xform(input)
	return input
