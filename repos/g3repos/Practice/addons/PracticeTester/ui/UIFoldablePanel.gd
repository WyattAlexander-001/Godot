# Panel with a button to animate folding and unfolding it.
extends Panel

enum AnchorSide { LEFT, RIGHT }

const APPEAR_DURATION := 0.9

export(AnchorSide) var anchor_side: int = AnchorSide.LEFT setget set_anchor_side
export var is_open := false setget set_is_open

var _fold_button := preload("FoldButton.tscn").instance() as Button
var _tween := Tween.new()

var open_position := 0.0
var closed_position := 0.0


func _ready() -> void:
	rect_position.x = closed_position
	add_child(_fold_button)
	add_child(_tween)
	set_anchor_side(anchor_side)

	_fold_button.connect("pressed", self, "toggle_open")
	_tween.connect("tween_completed", self, "_on_Tween_tween_completed")


func set_anchor_side(value: int) -> void:
	assert(value in [AnchorSide.LEFT, AnchorSide.RIGHT])
	anchor_side = value
	if not is_inside_tree():
		return

	match anchor_side:
		AnchorSide.LEFT:
			set_anchors_preset(PRESET_LEFT_WIDE)
			_zero_out_margins(self)
			_fold_button.set_anchors_preset(PRESET_CENTER_RIGHT)
			_zero_out_margins(_fold_button)
			_fold_button.rect_position -= _fold_button.rect_size / 2.0
			open_position = rect_position.x
			closed_position = open_position - rect_size.x
		AnchorSide.RIGHT:
			set_anchors_preset(PRESET_RIGHT_WIDE)
			_zero_out_margins(self)
			_fold_button.set_anchors_preset(PRESET_CENTER_LEFT)
			_zero_out_margins(_fold_button)
			_fold_button.rect_position -= _fold_button.rect_size / 2.0
			closed_position = rect_position.x
			open_position = closed_position - rect_size.x

	rect_position.x = open_position if is_open else closed_position


func set_is_open(value: bool) -> void:
	is_open = value
	if not is_inside_tree():
		return

	if is_open and not is_equal_approx(rect_position.x, open_position):
		appear()
	elif not is_open and not is_equal_approx(rect_position.x, closed_position):
		disappear()


func toggle_open() -> void:
	set_is_open(not is_open)


func appear() -> void:
	show()
	_tween.stop_all()
	_tween.interpolate_property(
		self,
		"rect_position:x",
		rect_position.x,
		open_position,
		APPEAR_DURATION,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	_tween.start()
	_tween.seek(0)


func disappear() -> void:
	_tween.stop_all()
	_tween.interpolate_property(
		self,
		"rect_position:x",
		rect_position.x,
		closed_position,
		APPEAR_DURATION,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	_tween.start()
	_tween.seek(0)


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if key == "rect_position:x" and not is_open:
		hide()


func _zero_out_margins(control: Control) -> void:
	control.margin_left = 0.0
	control.margin_right = 0.0
	control.margin_top = 0.0
	control.margin_bottom = 0.0
