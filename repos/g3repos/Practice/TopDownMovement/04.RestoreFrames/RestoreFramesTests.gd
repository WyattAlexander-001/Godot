extends PracticeTests

var sprite_does_flip := false
var frames := {
	"move_down": 0,
	"move_right": 2, 
	"move_left": 2,
	"move_up": 4, 
}
var frames_test := {
	"move_down": false,
	"move_right": false, 
	"move_left": false,
	"move_up": false, 
}

onready var sprite: Sprite = scene_root.get_node("Godot/Sprite")

func _init() -> void:
	add_requirement("Godot/Sprite")
	

func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")


func _ready() -> void:
	required_input_actions = ["move_right", "move_left", "move_up", "move_down"]


func _simulate_input_action() -> void:
	._simulate_input_action()
	if not _current_simulated_input:
		return

	if not sprite_does_flip and _current_simulated_input == "move_left" and sprite.flip_h:
		sprite_does_flip = true
	if not frames_test[_current_simulated_input] and sprite.frame == frames[_current_simulated_input]:
		frames_test[_current_simulated_input] = true


func test_sprite_flips_when_going_left() -> String:
	if not sprite_does_flip:
		return tr("Going to the left should flip the sprite horizontally but did not. Did you change the flip_h property of the sprite?")
	return ""


func _verify_input_maps_to_frame(input_name: String) -> String:
	if not frames_test[input_name]:
		return tr("Pressing the %s input does not change the sprite's frame as expected. In this direction, we expected the sprite to use frame number %s.") % [input_name, frames[input_name]]
	return ""


func test_sprite_shows_the_correct_up_frame() -> String:
	return _verify_input_maps_to_frame("move_up")


func test_sprite_shows_the_correct_down_frame() -> String:
		return _verify_input_maps_to_frame("move_down")


func test_sprite_shows_the_correct_left_frame() -> String:
	return _verify_input_maps_to_frame("move_left")


func test_sprite_shows_the_correct_right_frame() -> String:
	return _verify_input_maps_to_frame("move_right")
