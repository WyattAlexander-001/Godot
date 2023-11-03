extends PracticeTests

var directions := {
	"left": "direction.x=-1*",
	"right": "direction.x=1*",
	"up": "direction.y=-1*",
	"down": "direction.y=1*"
}
	
func _init() -> void:
	add_requirement("Godot/Sprite")


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1), "timeout")


func _verify_direction(direction_name: String, axis: String) -> String:
	var pattern = directions[direction_name]
	if not matches_code_line([pattern]):
		return tr(
			"It looks like the axis %s isn't properly handled. Did you give direction.%s a value?"
		) % [direction_name, axis]
	return ""

func test_input_up() -> String:
	return _verify_direction("up", "y")

func test_input_left() -> String:
	return _verify_direction("left", "x")

func test_input_right() -> String:
	return _verify_direction("right", "x")

func test_input_down() -> String:
	return _verify_direction("down", "y")
