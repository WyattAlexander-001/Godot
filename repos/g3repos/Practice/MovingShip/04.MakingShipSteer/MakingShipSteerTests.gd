extends PracticeTests

var key_affects_desired_velocity := true
var desired_velocity_affects_steering := true

var previous_velocity := Vector2.ZERO
var velocity_offsets := []
var sample_count := 0


func _init() -> void:
	add_requirement(".", ["boost_speed", "normal_speed", "max_speed", "direction", "velocity", "drag_factor", "desired_velocity", "steering_vector"])


func _ready() -> void:
	required_input_actions = ["move_right", "move_left", "move_up", "move_down"]
	connect("completed_actions_changed", self, "call_deferred", ["_test_ship_velocity"])


func _process(delta: float) -> void:
	if sample_count < 99:
		if scene_root.direction.length_squared() > 0.1:
			var new_offset: Vector2 = scene_root.velocity - previous_velocity
			if not new_offset.is_equal_approx(Vector2.ZERO):
				velocity_offsets.append(new_offset)
			previous_velocity = scene_root.velocity
			sample_count += 1


var steering_roughly_aligns_with_input_direction := true

func _test_ship_velocity() -> void:
	if scene_root.desired_velocity.is_equal_approx(Vector2.ZERO):
		key_affects_desired_velocity = false
		desired_velocity_affects_steering = false
	elif scene_root.steering_vector.is_equal_approx(Vector2.ZERO):
		desired_velocity_affects_steering = false
	elif scene_root.steering_vector.normalized().dot(scene_root.direction) < 0.3:
		steering_roughly_aligns_with_input_direction = false


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func test_desired_velocity_affects_steering() -> String:
	if not desired_velocity_affects_steering:
		return tr("Changes in the desired_velocity value should affect the steering_vector vector, but it does not.")
	return ""


func test_ship_steers_smoothly() -> String:
	if velocity_offsets.empty():
		return tr("It seems the ship is not moving, so we can't test for steering_vector.")
	for sample in velocity_offsets:
		if sample.length_squared() > scene_root.normal_speed * scene_root.normal_speed - 1.0:
			return tr("The ship changes orientation and velocity faster than it should. Did you multiply the steering_vector vector by drag_factor? And is the drag_factor lower or equal to 0.3?")
	return ""


func test_code_adds_steering_to_velocity() -> String:
	if not matches_code_line(["velocity+=*steering_vector*", "velocity=velocity+*steering_vector*"]):
		return tr("It seems that you're not adding a fraction of the steering_vector value to the velocity.")
	return ""


func test_steering_is_multiplied_by_drag_factor() -> String:
	if not matches_code_line(["*steering_vector*drag_factor*", "*drag_factor*steering_vector*"]):
		return tr("It seems the drag factor isn't taken into account. Did you multiply steering_vector by drag_factor when adding it to the velocity?")
	return ""

func test_velocity_calculation_is_correct() -> String:
	if matches_code_line(["*velocity+=*delta*", "*velocity=velocity+*delta*"]):
		return tr("It seems you use delta to change the velocity, but you shouldn't as we use delta when changing the ship's position already.")
	return ""
