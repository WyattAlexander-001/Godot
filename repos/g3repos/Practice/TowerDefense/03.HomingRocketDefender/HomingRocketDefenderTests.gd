extends PracticeTests

const HomingRocket := preload("HomingRocket.gd")
const TurretHoming := preload("TurretHoming.gd")

onready var turret := scene_root.get_node("Planet/TurretHoming")

func _init() -> void:
	add_requirement(".", [], ["_on_Timer_timeout"])
	add_requirement("Planet/TurretHoming/CollisionShape2D")
	add_requirement("Planet/TurretHoming/Sprite")
	add_requirement("Planet/TurretHoming", [], ["_on_body_entered", "_on_body_exited", "_on_Timer_timeout"])
	add_requirement("Timer")


func _prepare_async() -> void:
	yield(get_tree(), "idle_frame")
	var script: Script = turret.get_script()
	assert(
		script,
		(
			"The node %s should have a script but does not. Please add back its script."
			% turret.name
		)
	)
	code = _preprocess_code(script)
	randomize()
	yield(get_tree().create_timer(1.0), "timeout")


func test_method_is_overriden() -> String:
	if not matches_code_line(["func_on_Timer_timeout()*"]):
		return "It seems that you did not override the _on_Timer_timeout function. Please make sure you wrote the method name correctly"
	return ""


func test_is_using_correct_rocket_scene() -> String:
	if not matches_code_line(['*preload("*HomingRocket.tscn")*', "*preload('*HomingRocket.tscn')*"]):
		return "It doesn't look like you used the proper rocket scene. Are you preloading `HomingRocket.tscn`?"
	return ""


func test_is_passing_target_to_the_rocket() -> String:
	if not matches_code_line(["*.target=target"]):
		return "It looks like the rocket doesn't have a `target`. Did you assign the target to `rocket.target`?"
	return ""
	
func test_is_giving_initial_velocity_to_rocket() -> String:
	if not matches_code_line(["*.set_initial_velocity()"]):
		return "It looks like the rocket doesn't get an initial velocity. Did you call the proper function?"
	return ""
