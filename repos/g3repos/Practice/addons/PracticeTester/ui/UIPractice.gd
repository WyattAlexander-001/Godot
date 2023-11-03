# Displays the list of checks for the current practice, makes the PracticeTests script run tests, and displays the result.
extends Node

signal tests_updated

const UIPracticeCheckScene := preload("UIPracticeCheck.tscn")
const UIRequiredActionItemScene := preload("UIRequiredActionItem.tscn")
const UIOutputConsole := preload("UIOutputConsole.gd")

var _scene_root: Node
var _practice_tests: PracticeTests

onready var _panels := [$UIChecksPanel, $UIOutputConsole]

onready var _label: Label = $UIChecksPanel/Margin/Column/Label

onready var _checks_panel := $UIChecksPanel
onready var _checks: VBoxContainer = $UIChecksPanel/Margin/Column/Checks
onready var _checks_list: VBoxContainer = $UIChecksPanel/Margin/Column/Checks/Column

onready var _actions: VBoxContainer = $UIChecksPanel/Margin/Column/Actions
onready var _actions_list: VBoxContainer = $UIChecksPanel/Margin/Column/Actions/Column

onready var _output_console: UIOutputConsole = $UIOutputConsole

onready var _success_popup := $SuccessPopup as Control


func _ready() -> void:
	# If running this scene, exit.
	if get_viewport().has_node("@UIPractice@2"):
		return

	# When running a scene with F6, the practice scene should be the last child.
	var viewport := get_viewport()
	var scene_root := viewport.get_child(viewport.get_child_count() - 1)
	yield(scene_root, "ready")
	var script: Script = scene_root.get_script()
	if not script:
		print_debug(
			(
				"No script found on node %s. The practice system needs a script to work."
				% scene_root.get_path()
			)
		)
		for panel in _panels:
			panel.hide()
		return

	_practice_tests = load_practice_tests_script(script.resource_path)
	if not _practice_tests:
		_checks_panel.hide()
		return

	_practice_tests.setup(scene_root)
	add_child(_practice_tests)
	display_tests(_practice_tests.get_test_names())
	_checks_panel.is_open = true

	var error := _practice_tests.validate_requirements()
	if error:
		_output_console.is_open = true
		_output_console.print_error(error)
		_practice_tests.deactivate()
		return

	var has_remaining_actions := not _practice_tests.required_input_actions.empty()
	_actions.visible = has_remaining_actions
	if has_remaining_actions:
		_label.text = tr("Waiting for your input...")
		display_actions(_practice_tests.required_input_actions)
		_practice_tests.connect("completed_actions_changed", self, "update_completed_actions")
		yield(_practice_tests, "student_actions_completed")

	_label.text = tr("Checking your code...")
	var result: PracticeTests.TestResult = yield(_practice_tests.run_tests_async(), "completed")
	_label.text = tr("Done!")
	_output_console.is_open = true
	if result.is_success():
		UserProfiles.mark_complete(script.resource_path)
	yield(get_tree().create_timer(0.4), "timeout")

	yield(animate_checkmarks_async(result), "completed")

	if result.is_success():
		_success_popup.show()


func load_practice_tests_script(scene_script_path: String) -> PracticeTests:
	var dir := Directory.new()
	var head_and_tail := scene_script_path.rsplit("/", true, 1)
	var dirpath := head_and_tail[0]
	var scene_filename := head_and_tail[-1].get_basename()
	if dir.open(dirpath) != OK:
		printerr("Could not open directory %s." % dirpath)
		return null

	dir.list_dir_begin()
	var file_name = dir.get_next()
	var test_script_path := ""
	while not file_name.empty():
		if not dir.current_is_dir():
			# We only want to load tests if we're running the corresponding
			# scene.
			if (
				file_name.match("*Tests.gd")
				and file_name.get_basename() == scene_filename + "Tests"
			):
				test_script_path = dirpath.plus_file(file_name)
				break
		file_name = dir.get_next()

	return load(test_script_path).new() if not test_script_path.empty() else null


func display_tests(info: Array) -> void:
	for check in _checks_list.get_children():
		check.queue_free()

	for test in info:
		var instance := UIPracticeCheckScene.instance()
		instance.title = test
		_checks_list.add_child(instance)


func reset_tests_status_async() -> void:
	for check in _checks_list.get_children():
		check.unmark(true)


func set_tests_pending() -> void:
	for check in _checks_list.get_children():
		check.mark_as_pending(true)


func animate_checkmarks_async(test_result: PracticeTests.TestResult) -> void:
	var check_nodes := _checks_list.get_children()
	if check_nodes.empty():
		# Ensure asynchrosity even in invalid state.
		yield(get_tree(), "idle_frame")
		emit_signal("tests_updated")
		return

	# Update tests one by one with animation.
	for check in check_nodes:
		if check.title in test_result.errors:
			check.mark_as_failed()
			_output_console.print_error(test_result.errors[check.title])
			yield(check, "marking_finished")
		elif check.title in test_result.passed_tests:
			check.mark_as_passed()
			yield(check, "marking_finished")
		else:
			check.unmark(true)
			yield(check, "marking_finished")

	emit_signal("tests_updated")


func display_actions(actions: Array) -> void:
	for action in actions:
		var checkbox := UIRequiredActionItemScene.instance()
		checkbox.setup(action)
		_actions_list.add_child(checkbox)


func update_completed_actions() -> void:
	for action in _practice_tests.completed_actions:
		for checkbox in _actions_list.get_children():
			if not checkbox.pressed and checkbox.get_action() == action:
				checkbox.pressed = true
				break
