extends PracticeTests

var speed_went_down := true
var speed_went_back_up := true


func _init() -> void:
	add_requirement(".", [], ["_on_Timer_timeout"])
	add_requirement("Turret/CollisionShape2D")
	add_requirement("Turret/Sprite")
	add_requirement("Turret", [], ["_on_body_entered", "_on_body_exited"])
	add_requirement("Line2D")
	add_requirement("Timer")


func _prepare_async():
	._prepare_async()
	randomize()
	var turret: Area2D = scene_root.get_node("Turret")
	turret.connect("body_entered", self, "_on_Turret_body_entered")
	turret.connect("body_exited", self, "_on_Turret_body_exited")
	yield(get_tree().create_timer(2.0), "timeout")


func _on_Turret_body_entered(body: Node) -> void:
	yield(get_tree(), "idle_frame")
	if not is_equal_approx(body.get("speed"), 400.0):
		speed_went_down = false


func _on_Turret_body_exited(body: Node) -> void:
	yield(get_tree(), "idle_frame")
	if not speed_went_down or not is_equal_approx(body.get("speed"), 800.0):
		speed_went_back_up = false


func test_body_speed_is_divided_by_two_when_in_range() -> String:
	if not speed_went_down:
		return tr("At least one car's speed was not divided by two when entering the turret's area. Did you divide the body's speed by two?")
	return ""



func test_body_speed_goes_back_to_default_when_leaving_range() -> String:
	if not speed_went_back_up:
		return tr("At least one car's speed was not restored to the default when leaving the turret's area. Did you multiply the body's speed by two?")
	return ""
