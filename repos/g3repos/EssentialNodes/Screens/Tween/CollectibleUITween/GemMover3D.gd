extends Spatial

## Duration of the gem moving animation in seconds.
export var animation_time := 0.8
## Path to the UI node our 3D gems will animate to.
export(NodePath) var target_path
## Path to the camera node.
export(NodePath) var camera_path

onready var _target = get_node(target_path)
onready var _camera: Camera = get_node(camera_path)
onready var _gems: Spatial = $Gems
onready var _tween: Tween = $Tween

var _gem_count := 0


func _ready() -> void:
	for gem in _gems.get_children():
		gem.connect("collected", self, "_move_gem")


# Used to reset the tween when resetting the scene in Node Essentials.
func _enter_tree() -> void:
	if _tween:
		_tween.remove_all()
		for gem in _gems.get_children():
			gem.reset()


func _move_gem(gem: Gem) -> void:
	_tween.interpolate_property(
		gem,
		"translation",
		gem.translation,
		_camera.project_position(_target.position, 1.0),
		animation_time,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	# Shrink the gems as they move towards the camera else they'll take up too
	# much of the screen.
	_tween.interpolate_property(
		gem, "scale", gem.scale, Vector3.ZERO, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	_tween.start()
	_gem_count += 1
	_target._name_label.text = str(_gem_count)
