extends PracticeTests

const Rocket := preload("../common/Rocket.gd")

var turret: Area2D
var aims_at_target := true
var rockets_align_with_cannon := false


func _init() -> void:
	add_requirement(".", [], ["_on_Timer_timeout"])
	add_requirement("Planet/Turret/CollisionShape2D")
	add_requirement("Planet/Turret/Sprite")
	add_requirement(
		"Planet/Turret",
		["targets", "target_angle", "cannon"],
		["_on_body_entered", "_on_body_exited", "_on_Timer_timeout"]
	)
	add_requirement("Timer")


func _prepare_async():
	._prepare_async()
	randomize()
	turret = scene_root.get_node("Planet/Turret")
	turret.connect("rocket_spawned", self, "_on_rocket_spawned")
	yield(get_tree().create_timer(2.0), "timeout")


func _physics_process(delta: float) -> void:
	if turret.targets:
		var expected_angle = (turret.targets[0].global_position - turret.global_position).angle()
		aims_at_target = abs(turret.target_angle - expected_angle) < 0.1


func test_turret_turns_towards_mob() -> String:
	if not aims_at_target:
		return tr("The turret's target angle is not the angle to the first enemy. Did you update the target angle when there are targets in _physics_process()?")
	return ""


func test_turret_shoots_rocket_at_correct_angle() -> String:
	if not rockets_align_with_cannon:
		return tr("The fired rockets should have the same angle as the turret's cannon, but they do not. Did you update the rocket's global transform in _on_Timer_timeout()?")
	return ""


func _on_rocket_spawned(rocket_node: Rocket) -> void:
	yield(get_tree(), "idle_frame")
	rockets_align_with_cannon = abs(turret.cannon.global_rotation - rocket_node.global_rotation) < 0.05
