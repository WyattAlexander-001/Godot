extends PracticeTests

var did_double_jump := false
var jump_heights := []

# Needed because using Input.is_action_just_pressed() doesn't seem to work with the way
# we simulate input, yet we need to check only one frame after jumping.
var _is_first_jump_frame := true
var _has_checked := false

onready var character := scene_root.get_node("SideScrollDoubleJump") as KinematicBody2D


func _init() -> void:
	add_requirement("SideScrollDoubleJump", ["speed", "gravity", "jump_strengths"])


func _ready() -> void:
	required_input_actions = ["jump", "jump"]
	simulated_input_pressed_duration = 0.3
	release_input_time_interval = 0.075


func _simulate_input_action() -> void:
	._simulate_input_action()
	if Input.is_action_pressed("jump"):
		if not _is_first_jump_frame and not _has_checked:
			did_double_jump = character.velocity.y < 0.0
			_has_checked = true
		else:
			_is_first_jump_frame = false
	else:
		_is_first_jump_frame = true
		_has_checked = false


func _on_completed_actions_changed() -> void:
	if not required_input_actions:
		emit_signal("student_actions_completed")
		set_process_input(false)


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = character.get_script()
	code = _preprocess_code(script)
	yield(get_tree().create_timer(1.0), "timeout")


func test_limit_the_number_of_jumps() -> String:
	if not matches_code_line(["*if*jump_number<jump_strengths.size()*"]):
		return tr(
			"You need to limit the amounts of jumps the character can do. Are you checking if jump_number is lower than jump_strength's size?"
		)
	return ""

func test_increment_jump_number() -> String:
	var patterns := [
		"jump_number+=*",
		"jump_number=jump_number+*",
		"jump_number=*+jump_number",
	]
	if not matches_code_line(patterns):
		return tr(
			"It seems you're not increasing the jump number. Did you increment it when jumping?"
		)
	return ""

func test_reset_the_number_of_jumps_when_on_the_floor() -> String:
	if not (matches_code_line(["*if*is_on_floor():"]) and matches_code_line(["*jump_number=0*"])):
		return tr(
			"You need to reset the jump_number when the character is on the ground."
		)
	return ""

func test_character_performed_double_jump() -> String:
	if not did_double_jump:
		return tr("The character didn't perform a double jump. Did you increase jump_number? And did you set velocity.y to a negative value? You need a negative velocity to move the character up.")
	return ""
