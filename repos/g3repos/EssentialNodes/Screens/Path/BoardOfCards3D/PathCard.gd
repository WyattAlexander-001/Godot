extends Path

## Stores the position of every slot the card can move to.
## See `setup()` below for its initialization.
var _slot_positions := []
var _rng := RandomNumberGenerator.new()

onready var _path_follow: PathFollow = $PathFollow
onready var _card: MeshInstance = $PathFollow/BoardCard
# Each card has a visual border we use to detect when the player hovers and
# clicks the card. You can do that the Area node.
onready var _card_area: Area = $PathFollow/BoardCard/Area
onready var _tween: Tween = $Tween


func setup(slot_positions: Array) -> void:
	_slot_positions = slot_positions


func _ready() -> void:
	_card_area.connect("input_event", self, "_on_CardArea_input_event")
	_card_area.connect("mouse_entered", self, "_on_CardArea_mouse_entered_exited", [true])
	_card_area.connect("mouse_exited", self, "_on_CardArea_mouse_entered_exited", [false])
	_rng.randomize()

	# We need this line in node essentials to clear debug path drawings when resetting scenes.
	curve.clear_points()


## Brings the card in front and animates it with a vertical offsset.
func _on_CardArea_mouse_entered_exited(has_entered: bool) -> void:
	var start_position := Vector3(0, _card.translation.y, _card.translation.z)
	var target_position := Vector3.ZERO
	if has_entered:
		target_position = Vector3(0, 0.25, 0.1)

	_tween.stop_all()
	_tween.interpolate_property(_card, "translation", start_position, target_position, 0.1)
	_tween.start()


# The `Area` `input_event` signal emits when the player applies input to the node,
# for example, by clicking on it. It won't trigger if the player clicks elsewhere
# on the screen.
func _on_CardArea_input_event(
		_camera: Node,
		event: InputEvent,
		_click_position: Vector3,
		_click_normal: Vector3,
		_shape_idx: int
	) -> void:
	if event.is_action_pressed("click"):
		# Get the next slot position, this will also shrink the array.
		var slot_position: Vector3 = _slot_positions.pop_back()

		# Find the mean position between the card and the slot and apply
		# a random offset on the X axis for added variation.
		var offset: Vector3 = (_path_follow.translation + slot_position) / 2.0
		offset.x += _rng.randf_range(-1, 1)

		# Add the points to the curve: the current card position, the middle offset and
		# the final slot position.
		curve.clear_points()
		curve.add_point(_path_follow.translation)
		curve.add_point(offset)
		curve.add_point(slot_position)

		# Here, we animate the card moving along the path.
		_tween.stop_all()
		_tween.interpolate_property(
			_path_follow, "unit_offset", 0, 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT
		)

		# We also animate the rotation with the `Tween` node because we want a specific orientation
		# to match the table. For that reason we have `PathFollow.rotation_mod = ROTATION_NONE`.
		_tween.interpolate_property(
			_path_follow, "rotation:x", _path_follow.rotation.x,
			-PI / 2.0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		_tween.interpolate_property(
			_path_follow, "rotation:y", _path_follow.rotation.y,
			_rng.randf_range( -PI, PI) / 20.0, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT
		)

		# We animate the card going up when hovering it with the mouse. So we
		# need to move it back to its original position quickly to avoid having
		# it offset from the card slot.
		_tween.interpolate_property(_card, "translation:y", _card.translation.y, 0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN, 0.7)
		_tween.start()

		# Once the player placed a card, they shouldn't be able to click it
		# anymore. That's why we disconnect from the signals.
		_card_area.disconnect("input_event", self, "_on_CardArea_input_event")
		_card_area.disconnect("mouse_entered", self, "_on_CardArea_mouse_entered_exited")
		_card_area.disconnect("mouse_exited", self, "_on_CardArea_mouse_entered_exited")
