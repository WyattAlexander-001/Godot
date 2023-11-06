extends Path2D

## Stores the position of every slot the card can move to.
## See `setup()` below for its initialization.
var _slot_positions := []
var _rng := RandomNumberGenerator.new()

onready var _path_follow: PathFollow2D = $PathFollow2D
onready var _card: Node2D = $PathFollow2D/BoardCard
# Each card has a visual border we use to detect when the player hovers and
# clicks the card. You can do that with any Control node.
onready var _card_border: PanelContainer = $PathFollow2D/BoardCard/CardBorder
onready var _tween: Tween = $Tween


func setup(slot_positions: Array) -> void:
	_slot_positions = slot_positions


func _ready() -> void:
	_card_border.connect("gui_input", self, "_on_CardBorder_gui_input")
	_card_border.connect("mouse_entered", self, "_on_CardBorder_mouse_entered_exited", [true])
	_card_border.connect("mouse_exited", self, "_on_CardBorder_mouse_entered_exited", [false])
	_rng.randomize()

	# We need this line in node essentials to clear debug path drawings when resetting scenes.
	curve.clear_points()


## Brings the card in front and animates it with a vertical offsset.
func _on_CardBorder_mouse_entered_exited(has_entered: bool) -> void:
	z_index = 0
	var start_position := _card.position.y
	var target_position := 0.0
	if has_entered:
		z_index = 1
		target_position = -50.0

	_tween.stop_all()
	_tween.interpolate_property(_card, "position:y", start_position, target_position, 0.1)
	_tween.start()


# The gui_input signal emits when the player applies input to the node, for
# example, by clicking on it. It won't trigger if the player clicks elsewhere on
# the screen.
func _on_CardBorder_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		# Bring the card on top of the others using the `_slot_positions` size.
		z_index = _slot_positions.size()

		# Get the next slot position, this will also shrink the array.
		var slot_position: Vector2 = _slot_positions.pop_back()

		# Find the mean vertical position between the card and the slot and apply
		# a random horizontal offset for added variation.
		var offset: Vector2 = (_path_follow.position + slot_position) / 2.0
		offset.x += _rng.randf_range(-200, 200)

		# Add the points to the curve: the current card position, the middle offset and
		# the final slot position.
		curve.clear_points()
		curve.add_point(_path_follow.position)
		curve.add_point(offset)
		curve.add_point(slot_position)

		# Here, we animate the card moving along the path.
		_tween.stop_all()
		_tween.interpolate_property(
			_path_follow, "unit_offset", 0, 1, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT
		)
		# We animate the card going up when hovering it with the mouse. So we
		# need to move it back to its original position quickly to avoid having
		# it offset from the card slot.
		_tween.interpolate_property(
			_card, "position:y", _card.position.y, 0, 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN, 0.7
		)
		_tween.interpolate_callback(self, 0.8, "set_z_index", 0)
		_tween.start()

		# Once the player placed a card, they shouldn't be able to click it
		# anymore. That's why we disconnect from the signals.
		_card_border.disconnect("mouse_entered", self, "_on_CardBorder_mouse_entered_exited")
		_card_border.disconnect("mouse_exited", self, "_on_CardBorder_mouse_entered_exited")
		_card_border.disconnect("gui_input", self, "_on_CardBorder_gui_input")
