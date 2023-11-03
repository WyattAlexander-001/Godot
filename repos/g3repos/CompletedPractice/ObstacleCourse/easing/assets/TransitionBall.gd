tool
extends Control

signal animation_style_changed(style)
signal duration_changed(duration)

# UI Nodes
onready var _ui_container := $VBoxContainer as VBoxContainer
onready var _easing_option_button := $"%EasingOptionButton" as OptionButton
onready var _transition_option_button := $"%TransitionOptionButton" as OptionButton
onready var _duration_slider := $"%DurationSlider" as HSlider
onready var _duration_slider_label := $"%DurationSliderLabel" as Label
onready var _animation_style_option_button := $"%AnimationStyleOptionButton" as OptionButton
onready var _transition_label := $"%TransitionLabel" as Label
onready var _easing_label := $"%EasingLabel" as Label


# Animated objects
onready var _ball := $"%Ball" as Sprite
onready var _shadow := $"%Shadow" as Sprite
onready var _assets_container := $"%AssetsContainer" as VBoxContainer
onready var _ball_height := _ball.texture.get_size().y / 2

# if this is set, the current node will hide it's UI and follow the provided 
# node to sync duration and animation style
export var node_to_compare_to: NodePath = ""


# Values changed by the User
var _transition := Tween.TRANS_LINEAR
var _easing := Tween.EASE_IN_OUT
var _duration := 1.25 setget set_duration
var _animation_style: int = ANIMATION.MOVE setget set_animation_style

# Tweens
var _tween: SceneTreeTween
var _method_tweener: MethodTweener
var _method_tweener_back: MethodTweener

# Values for the UI
const TransitionType := {
	TRANS_LINEAR = [Tween.TRANS_LINEAR, "The animation is interpolated linearly."],
	TRANS_SINE = [Tween.TRANS_SINE, "The animation is interpolated using a sine function."],
	TRANS_QUINT = [Tween.TRANS_QUINT, "The animation is interpolated with a quintic (to the power of 5) function."],
	TRANS_QUART = [Tween.TRANS_QUART, "The animation is interpolated with a quartic (to the power of 4) function."],
	TRANS_QUAD = [Tween.TRANS_QUAD, "The animation is interpolated with a quadratic (to the power of 2) function."],
	TRANS_EXPO = [Tween.TRANS_EXPO, "The animation is interpolated with an exponential (to the power of x) function."],
	TRANS_ELASTIC = [Tween.TRANS_ELASTIC, "The animation is interpolated with elasticity, wiggling around the edges."],
	TRANS_CUBIC = [Tween.TRANS_CUBIC, "The animation is interpolated with a cubic (to the power of 3) function."],
	TRANS_CIRC = [Tween.TRANS_CIRC, "The animation is interpolated with a function using square roots."],
	TRANS_BOUNCE = [Tween.TRANS_BOUNCE, "The animation is interpolated by bouncing at the end."],
	TRANS_BACK = [Tween.TRANS_BACK, "The animation is interpolated backing out at ends."],
}

# Values for the UI
const EaseType := {
	EASE_IN = [Tween.EASE_IN, "The interpolation starts slowly and speeds up towards the end."],
	EASE_OUT = [Tween.EASE_OUT, "The interpolation starts quickly and slows down towards the end."],
	EASE_IN_OUT = [Tween.EASE_IN_OUT, "A combination of EASE_IN and EASE_OUT. The interpolation is slowest at both ends."],
	EASE_OUT_IN = [Tween.EASE_OUT_IN, "A combination of EASE_IN and EASE_OUT. The interpolation is fastest at both ends."],
}

# Possible animations
enum ANIMATION {
	MOVE,
	SCALE
}

# Values for the UI
const AnimationStyle := {
	Move = [ANIMATION.MOVE, "Move Up and Down"],
	Scale = [ANIMATION.SCALE, "Scale"]
}


func _ready() -> void:
	# if we're comparing ourselves to a node, we just copy its properties
	# No UI necessary
	if node_to_compare_to:
		var control:= get_node(node_to_compare_to)
		if control is get_script():
			set_animation_style(control._animation_style)
			control.connect("animation_style_changed", self, "set_animation_style")
			set_duration(control._duration)
			control.connect("duration_changed", self, "set_duration" )
			_ui_container.hide()
	if Engine.editor_hint:
		return
	# we populate and connect the UI either way to avoid future potential bugs due
	# to slightly changed expectations between the version with UI and the version
	# without.
	_duration_slider.connect("value_changed", self, "_on_TimeSlider_value_changed")
	_duration_slider.value = _duration
	_duration_slider_label.text = "Time: %ss" %[str(_duration)]
	
	_prepare_optionButton(_transition_option_button, TransitionType, _transition, "_on_TransitionOptionButton_item_selected")
	_transition_label.text = _transition_option_button.get_item_text(_transition_option_button.get_selected_id())
	
	_prepare_optionButton(_easing_option_button, EaseType, _easing, "_on_EasingOptionButton_item_selected")
	_easing_label.text = _easing_option_button.get_item_text(_easing_option_button.get_selected_id())
	
	_prepare_optionButton(_animation_style_option_button, AnimationStyle, _animation_style, "_on_AnimationStyleOptionButton_item_selected")

	_start_tweening()


# Starts the tweening process. Also called after changing the Tween's duration
func _start_tweening() -> void:
	if _tween:
		_tween.kill()
		_tween = null
	
	_tween = create_tween()
	_tween.set_trans(_transition)
	_tween.set_ease(_easing)
	_method_tweener = _tween.tween_method(self, "_animate", 0.0, 1.0, _duration)
	_method_tweener_back = _tween.tween_method(self, "_animate", 1.0, 0.0, _duration)
	_tween.set_loops()


# Tween callback, called on each frame
func _animate(value: float) -> void:
	
	var margin := 80.0
	
	var start := - _ball_height - margin
	var end := - _assets_container.rect_size.y + _ball_height + margin
	
	match _animation_style:
		ANIMATION.MOVE:
			_ball.position.y = lerp(start, end, value) 
		ANIMATION.SCALE:
			_ball.position.y = end / 2 - _ball_height
			_ball.scale = Vector2.ONE * lerp(1.5, 0.7, value)
	
	_shadow.position.y = - _ball_height + margin
	_shadow.modulate.a = lerp(.5, .2, value)
	_shadow.scale = Vector2.ONE * lerp(1, 0.3, value)


# Utility function. Does a triangle wave interpolation between two values, provided a factor between
# 0 and 1
static func oscillate(lower_bound: float, upper_bound: float, unit: float) -> float:
  var _range = upper_bound - lower_bound;
  return lower_bound + _range * 2.0 * (0.5 - abs(fmod(unit, 1.0) - 0.5));


# Adds options to an OptionButton, and connects it to a callback
func _prepare_optionButton(option_button: OptionButton, dict: Dictionary, initial: int, callback: String) -> void:
	var keys := dict.keys()
	for idx in keys.size():
		var key: String = keys[idx]
		var value: Array = dict[key]
		var constant: int = value[0]
		var description: String = value[1]
		option_button.add_item(key, idx)
		option_button.set_item_metadata(idx, constant)
		option_button.set_item_tooltip(idx, description)
		if constant == initial:
			option_button.select(idx)
	option_button.connect("item_selected", self, callback, [option_button])


# When the transition button is changed
func _on_TransitionOptionButton_item_selected(idx: int, option_button: OptionButton) -> void:
	_transition = option_button.get_item_metadata(idx)
	_method_tweener.set_trans(_transition)
	_method_tweener_back.set_trans(_transition)
	_transition_label.text = option_button.get_item_text(idx)


# When the easing button is changed
func _on_EasingOptionButton_item_selected(idx: int, option_button: OptionButton) -> void:
	_easing = option_button.get_item_metadata(idx)
	_method_tweener.set_ease(_easing)
	_method_tweener_back.set_ease(_easing)
	_easing_label.text = option_button.get_item_text(idx)


# When the animation style button is changed
func _on_AnimationStyleOptionButton_item_selected(idx: int, option_button: OptionButton) -> void:
	set_animation_style(option_button.get_item_metadata(idx))


# When the duration slider is changed
func _on_TimeSlider_value_changed(value: float):
	set_duration(value)


# sets the animation style, and dispatches a signal
func set_animation_style(style: int) -> void:
	if style == _animation_style:
		return
	_animation_style = style
	emit_signal("animation_style_changed", _animation_style)


# sets the animation duration, and dispatches a signal
func set_duration(duration: float) -> void:
	if is_equal_approx(duration, _duration):
		return
	_duration = duration
	_duration_slider_label.text = "Time: %ss" %[str(_duration)]
	_start_tweening()
	emit_signal("duration_changed", _duration)
