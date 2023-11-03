extends PracticeTests

var sprite_does_flip := false


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")
	


func _ready() -> void:
	required_input_actions = ["move_right", "move_left"]


func _simulate_input_action() -> void:
	._simulate_input_action()
	if not sprite_does_flip and _current_simulated_input == "move_left":
		sprite_does_flip = scene_root.get_node("Godot/Sprite").flip_h


func test_sprite_flips_when_going_left() -> String:
	if not sprite_does_flip:
		return tr(
			"Going to the left does not flip the sprite. Did you change the sprite's flip_h property based on the player's input direction?"
		)
	return ""
