tool
extends Camera2D

export var target_a: NodePath
export var target_b: NodePath
export var target_c: NodePath

var _targets := []
var _current_target: Node2D


func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
		return

	# We get and validate the reference to each target and store them in an array.
	for path in [target_a, target_b, target_c]:
		var target_node := get_node(path) as Node2D
		assert(target_node)
		_targets.append(target_node)

	_current_target = _targets[0]
	global_position = _current_target.global_position


func _unhandled_input(event: InputEvent) -> void:
	# Here, we cycle the targets.
	if event.is_action_pressed("interact"):
		_targets.push_back(_targets.pop_front())
		_current_target = _targets[0]
		get_tree().set_input_as_handled()


# With smoothing on, all we have to do is set the camera to the target's
# position and the engine takes care of smoothly moving to it.
func _physics_process(_delta: float) -> void:
	global_position = _current_target.global_position


## This function displays a warning if the node isn't set up properly. Here, we
## ensure every node path points to a 2D node.
func _get_configuration_warning() -> String:
	var warning := ""
	for node_path in [target_a, target_b, target_c]:
		if not get_node_or_null(node_path) as Node2D:
			warning = (
				"Each path property must point to a 2D node. "
				+ "Add paths pointing to these nodes in the Inspector."
			)
			break
	return warning
