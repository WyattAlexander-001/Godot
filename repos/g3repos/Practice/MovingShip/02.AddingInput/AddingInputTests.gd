extends PracticeTests

const VELOCITY_ERROR_MARGIN := 10.0

var did_all_keys_change_direction := true

var is_velocity_code_ok := true
var is_velocity_added_to_ship := false
var is_velocity_vector_long_as_max_speed := true

var _direction_message := ""


func _init() -> void:
	add_requirement(".", ["max_speed", "velocity"])


func _ready() -> void:
	required_input_actions = ["move_right", "move_left", "move_up", "move_down"]
	connect("completed_actions_changed", self, "call_deferred", ["_test_direction"])



func _prepare_async():
	._prepare_async()
	yield(get_tree(), "idle_frame")
	is_velocity_added_to_ship = matches_code_line(["position*=*velocity*delta", "position*=*delta*velocity"])


func _test_direction() -> void:
	if scene_root.velocity.is_equal_approx(Vector2.ZERO):
		did_all_keys_change_direction = false


func _simulate_input_action() -> void:
	._simulate_input_action()
	call_deferred("_compare_input_and_velocity")


func _compare_input_and_velocity() -> void:
	var length: float = scene_root.velocity.length()
	if length <= scene_root.max_speed - VELOCITY_ERROR_MARGIN:
		is_velocity_vector_long_as_max_speed = false
	
	if is_equal_approx(length, 0.0):
		is_velocity_code_ok = false
	
	if Input.is_action_pressed("move_right") and (scene_root.velocity.x < 0.0 or not is_equal_approx(scene_root.velocity.y, 0.0)):
		is_velocity_code_ok = false
		_direction_message = tr("When pressing the move_right action, the ship went left instead of right.")
	elif Input.is_action_pressed("move_left") and (scene_root.velocity.x > 0.0 and not is_equal_approx(scene_root.velocity.y, 0.0)):
		is_velocity_code_ok = false
		_direction_message = tr("When pressing the move_left action, the ship went right instead of left.")
	elif Input.is_action_pressed("move_up") and (scene_root.velocity.y > 0.0 and not is_equal_approx(scene_root.velocity.x, 0.0)):
		is_velocity_code_ok = false
		_direction_message = tr("When pressing the move_up action, the ship went down instead of up.")
	elif Input.is_action_pressed("move_down") and scene_root.velocity.y < 0.0 and not is_equal_approx(scene_root.velocity.y, 0.0):
		is_velocity_code_ok = false
		_direction_message = tr("When pressing the move_down action, the ship went up instead of down.")


func test_direction_uses_get_axis_function() -> String:
	if not matches_code_line(["*Input.get_axis(*)"]):
		return tr(
			"You need to use the Input.get_axis() function to get the ship's movement direction."
		)
	return ""


func test_get_axis_calls_use_correct_move_actions() -> String:
	return _direction_message


func test_direction_vector_moves_ship() -> String:
	if not (is_velocity_code_ok and is_velocity_added_to_ship):
		return tr("One or more of the four direction keys did not move the ship.")
	return ""


func test_movement_uses_direction_and_max_speed() -> String:
	if not is_velocity_vector_long_as_max_speed:
		return tr("The velocity should be equal to direction * max_speed. It seems that it is not the case. Did you perhaps multiply the max_speed by delta?")
	return ""


func test_direction_is_normalized_if_greater_than_one() -> String:
	if not matches_code_line(["direction=direction.normalized()"]):
		return tr("We didn't find a line of code that normalized the direction vector. Did you assign direction.normalized()?")
	return ""
