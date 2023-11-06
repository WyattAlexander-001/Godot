extends Control

onready var _button_container: VBoxContainer = $VBoxContainer
# This button takes the player's focus when all Buttons become enabled again.
onready var _first_button: TextureButton = $VBoxContainer/ActionButton1

# This Timer determines long to disable the buttons for after making an attack.
onready var _disable_tween: Tween = $DisableTween
onready var _progress_bar: ProgressBar = $VBoxContainer/ProgressBar

# Visual-only cursor to show the player's current choice.
onready var _cursor: Position2D = $Cursor
onready var _cursor_tween: Tween = $Cursor/Tween

onready var _attack_animations: AnimationPlayer = $AttackAnimations

func _ready() -> void:
	# This timeout signal re-enables all buttons after the player makes a choice.
	_disable_tween.connect("tween_all_completed", self, "_set_buttons_disabled", [false])
	
	for child in _button_container.get_children():
		if child is TextureButton:
			child.connect("pressed", self, "_on_ActionButton_pressed", [child])
			child.connect("mouse_entered", self, "_move_cursor_to", [child.get_global_rect().position])
			child.connect("focus_entered", self, "_move_cursor_to", [child.get_global_rect().position])
	
	# Allow all buttons to be pressed at the start of the scene.
	_set_buttons_disabled(false)

## Disables and prevent buttons from being focused, hides the cursor.
func _set_buttons_disabled(is_disabled: bool) -> void:
	for child in _button_container.get_children():
		# Ignore non-button children from this loop.
		if child is TextureButton:
			child.disabled = is_disabled
			child.focus_mode = Control.FOCUS_NONE if is_disabled else Control.FOCUS_ALL
	
	# Hide the cursor to help indicate if the buttons are enabled or not.
	_cursor_tween.interpolate_property(_cursor, "modulate:a", 1.0 if is_disabled else 0.0, 0.0 if is_disabled else 1.0, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_cursor_tween.start()
	
	# If we're enabling all buttons, grab the focus of the first button to let non-mouse users navigate the buttons.
	if not is_disabled:
		_first_button.grab_focus()


## Tweens the cursor's position to focused ActionButton.
func _move_cursor_to(position: Vector2) -> void:
	_cursor_tween.interpolate_property(_cursor, "position", _cursor.position, position, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	_cursor_tween.start()


## Matches the Button text to play a corresponding animation.
func _on_ActionButton_pressed(pressed_button: TextureButton) -> void:
	_move_cursor_to(pressed_button.get_global_rect().position)
	match pressed_button.text:
		"Icestorm", "Fire", "Snowstorm":
			_attack_animations.play(pressed_button.text)
		var unexpected_case:
			push_error("Pressed button text \"%s\" was not found in _on_ActionButton_pressed." % [unexpected_case])
	# Disable all buttons. The timer's timeout signal will re-enable them.
	_set_buttons_disabled(true)
	_disable_tween.interpolate_property(_progress_bar, "value", 100, 0, 2.0)
	_disable_tween.start()
