extends PracticeTests

const Marble := preload("Marble.gd")

onready var marble := scene_root.get_node("Marble") as Marble

func _init() -> void:
	add_requirement("Marble", [], ["_on_DragArea_requested_move"])


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = marble.get_script()
	code = _preprocess_code(script)
	yield(get_tree().create_timer(1.0), "timeout")


func test_impulse_is_properly_applied() -> String:
	if not matches_code_line(["apply_central_impulse*"]):
		if matches_code_line(["apply_impulse*"]):
			return tr("It seems you've used `apply_impulse()`. Please use `apply_central_impulse()` instead!")
		if matches_code_line(["*?.apply_central_impulse*", "*?.apply_impulse*"]):
			return tr("It looks like you're calling `apply_central_impulse()` on a child of the marble. The marble is itself a RigidBody, you can call `apply_central_impulse()` directly!")
		return tr("There doesn't seem to be an impulse applied on the marble. Did you use the proper method?")
	return ""
