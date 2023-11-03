extends PracticeTests

const Robot := preload("../01.AddingDoubleJump/SideScrollDoubleJump.gd")
const JumpPad := preload("JumpPad.gd")

onready var character := scene_root.get_node("SideScrollDoubleJump") as Robot
onready var jump_pad := scene_root.get_node("JumpPad") as JumpPad

func _init() -> void:
	add_requirement("SideScrollDoubleJump", ["speed", "gravity", "jump_strengths"])
	add_requirement("JumpPad", ["jump_increase_amount"])


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = jump_pad.get_script()
	code = _preprocess_code(script)
	yield(get_tree().create_timer(1.0), "timeout")

func test_jumpad_increases_player_velocity() -> String:
	var robot := Robot.new()
	jump_pad._on_body_entered(robot)
	if robot.velocity.y != -jump_pad.jump_increase_amount:
		return tr("The jumpad did not increase the robot's velocity. Did you increase the `velocity.y`?")
	return ""

func test_jumpad_prevents_triple_jump() -> String:
	var robot := Robot.new()
	jump_pad._on_body_entered(robot)
	if robot.jump_number < 1:
		return tr("The jumpad did not change the robot's jumps amount. Did you increase jump_number?")
	return ""
