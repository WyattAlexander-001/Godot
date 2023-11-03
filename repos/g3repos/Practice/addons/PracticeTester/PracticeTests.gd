# Tests the code entered by a student in a given practice using a series of
# functions.
#
# Extend this script to create tests. You must override the _prepare_async()
# coroutine. Use it to make the user's practice process and return when done
# preparing.
#
# To add a test, write a new method with a name starting with `test_`. The
# method should take no argument and return a String: an optional error message.
#
# If the returned string is empty, the test passed. If the string is not empty,
# the test failed.
class_name PracticeTests
extends Node

# Emitted when the student completed some actions required to test properly.
# Before emitting this signal, you should set `requires_student_action` to
# `true`.
signal student_actions_completed
signal completed_actions_changed

# Array of Requirements objects used to check if required nodes, methods, and
# properties exist in the scene.
var requirements := []

var code := []
var required_input_actions := []
var completed_actions := []

var scene_root: Node

# Time a simulated input action stays pressed in seconds.
var simulated_input_pressed_duration := 0.5
# Optional wait time between input actions presses.
var release_input_time_interval := 0.0
# If true, forces the simulated input action to be pressed every frame. Use this
# for practices that use Input.is_action_just_pressed() inside _process() to get
# the condition to pass.
var force_continuous_simulated_key_presses := false

var _test_methods := _find_test_method_names()
# Input action to simulate pressing in _process()
var _current_simulated_input := ""

onready var tree := get_tree()


func _ready() -> void:
	connect("ready", self, "_run_required_input_actions")


func _process(delta: float) -> void:
	if _current_simulated_input:
		_simulate_input_action()


func setup(scene_root_node: Node) -> void:
	scene_root = scene_root_node


func get_test_names() -> Array:
	return _test_methods.values()


# Tests every Requirements object in the requirements array. If any requirement
# is missing in the test scene, returns an error message.
func validate_requirements() -> String:
	for requirement in requirements:
		var error: String = requirement.test(scene_root)
		if error:
			return error
	return ""


func run_tests_async() -> TestResult:
	var result := TestResult.new()

	yield(_prepare_async(), "completed")

	for method in _test_methods:
		var test_name = _test_methods[method]

		var error_message: String = call(method)
		if error_message != "":
			result.errors[test_name] = error_message
		else:
			# We pass the test name to display it in the interface.
			result.passed_tests.push_back(_test_methods[method])

	_clean_up()

	return result


# Registers a required node with a number of required properties and functions.
func add_requirement(path: NodePath, properties := [], methods := [], signal_connections := []) -> void:
	requirements.append(Requirements.new(path, properties, methods, signal_connections))


func deactivate() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)


# Returns true if one of the `patterns` is found in one of the lines of `code`.
func is_pattern_in_code(patterns: Array) -> bool:
	for line in code:
		for pattern in patterns:
			if pattern in line:
				return true
	return false


# Returns true if a line in the input `code` matches one of the `target_lines`.
# Uses String.match to match lines, so you can use ? and * in `target_lines`.
func matches_code_line(target_lines: Array) -> bool:
	for line in code:
		for match_pattern in target_lines:
			if line.match(match_pattern):
				return true
	return false


# Returns true if a line in the input `code` matches one of the `target_lines`.
# Uses RegEx to match lines.
func matches_code_line_regex(regex_patterns: Array) -> bool:
	var regexes = []
	for pattern in regex_patterns:
		var regex := RegEx.new()
		regex.compile(pattern)
		regexes.append(regex)

	for line in code:
		for regex in regexes:
			var m = regex.search(line)
			if regex.search(line):
				return true
	return false


# Takes a script resource and converts its source code into an array of stripped
# strings with no spaces. Ignores comment lines.
func _preprocess_code(script: Script) -> Array:
	var output := []
	var code := script.source_code

	for line in code.split("\n"):
		line = line.strip_edges().replace(" ", "")
		if not line.empty() or not line.begins_with("#"):
			output.append(line)
	return output


func _find_test_method_names() -> Dictionary:
	var output := {}

	var methods := []
	for method in get_method_list():
		if method.name.begins_with("test_"):
			methods.append(method.name)

	methods.sort()

	for method in methods:
		output[method] = method.trim_prefix("test_").capitalize()

	return output


# Called before running tests. When overriding it, you must use a coroutine.
func _prepare_async() -> void:
	yield(tree, "idle_frame")
	var script: Script = scene_root.get_script()
	assert(
		script,
		(
			"The node %s should have a script but does not. Please add back its script."
			% scene_root.name
		)
	)
	code = _preprocess_code(script)


# Virtual method.
# Called after running tests.
func _clean_up() -> void:
	pass


func _run_required_input_actions() -> void:
	if not required_input_actions:
		return

	yield(tree.create_timer(0.5), "timeout")

	for action in required_input_actions:
		_current_simulated_input = action
		Input.action_press(_current_simulated_input)

		yield(tree.create_timer(simulated_input_pressed_duration), "timeout")

		Input.action_release(action)

		if release_input_time_interval > 0.0:
			_current_simulated_input = ""
			yield(tree.create_timer(release_input_time_interval), "timeout")

		completed_actions.append(action)
		emit_signal("completed_actions_changed")

	_current_simulated_input = ""
	emit_signal("student_actions_completed")


# Called in _process()
func _simulate_input_action() -> void:
	if _current_simulated_input:
		if force_continuous_simulated_key_presses or (not Input.is_action_pressed(_current_simulated_input)):
			Input.action_press(_current_simulated_input)


class TestResult:
	# List of tests passed successfully in the test suite.
	var passed_tests := []
	var errors := {}
	var requirements_error := ""

	func is_success() -> bool:
		return errors.empty()


class Requirements:
	var node_path: NodePath
	var properties := []
	var methods := []
	var connected_signals := []

	func _init(p_path: NodePath, p_properties := [], p_methods := [], p_connected_signals = []) -> void:
		node_path = p_path
		properties = p_properties
		methods = p_methods
		connected_signals = p_connected_signals

	# Tests that the scene has the desired node, methods, and properties. If any
	# is missing, returns a corresponding error message.
	func test(scene_root: Node) -> String:
		var node: Node = scene_root.get_node_or_null(node_path)
		if not node:
			var node_name := node_path.get_name(node_path.get_name_count() - 1)
			return (
				tr('Node named "%s" at path "%s" required to run checks but we couldn\'t find it. Did you create a node named "%s" at the correct path?')
				% [node_name, node_path, node_name]
			)

		for method in methods:
			if not node.has_method(method):
				return (
					tr('Node "%s" needs to have the function "%s" to run checks. Did you not define a function named "%s" in the script?')
					% [node.name, method, method]
				)

		var properties_metadata: Array = node.get_property_list()
		var property_names := []
		for dict in properties_metadata:
			property_names.append(dict.name)

		for property in properties:
			if not property in property_names:
				return (
					tr('Node "%s" needs to have the property "%s" to run checks. Did you remove a predefined variable named "%s" at the top of the script? Or did you not define one?')
					% [node.name, property, property]
				)

		for signal_name in connected_signals:
			if not node.has_signal(signal_name):
				return tr('Node "%s" needs to have the signal "%s" to run checks. Did you remove the definition of signal "%s" at the top of the script? Or did you forget to define the signal?' % [node.name, signal_name, signal_name])

			var connections := node.get_signal_connection_list(signal_name)
			if connections.empty():
				return tr('Node "%s" should have its signal "%s" connected to some other node for this practice to work. Did you forget to connect it?' % [node.name, signal_name])

		return ""
