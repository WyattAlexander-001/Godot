extends NinePatchRect

const STYLE_ERROR := preload("res://common/UI/lineedit_stylebox_error.tres")
const STYLE_FOCUS := preload("res://common/UI/lineedit_stylebox_focus.tres")

var hash_pass := "7c6a180b36896a0a8c02787eeafb0e4c"
var email := "me@email.com"

var email_regex := RegEx.new()

onready var _password_line: LineEdit = $VBoxContainer/PasswordLineEdit
onready var _email_line: LineEdit = $VBoxContainer/EmailLineEdit
onready var _animator: AnimationPlayer = $AnimationPlayer
onready var _button: Button = $VBoxContainer/Button
onready var _label: Label = $VBoxContainer/Label
onready var _tween: Tween = $Tween


func _ready() -> void:
	_email_line.grab_focus()
	email_regex.compile('.+\\@.+\\.[a-z][a-z]+')
	_email_line.connect("text_changed", self, "_on_EmailLineEdit_text_changed")
	_email_line.connect("focus_exited", _label, "set_text", [""])
	_password_line.connect("text_entered", self, "_on_PasswordLineEdit_text_entered")
	_button.connect("pressed", self, "attempt_to_login")


func attempt_to_login() -> void:
	var are_credentials_good := (
		_email_line.text == email
		and _password_line.text.md5_text() == hash_pass
	)
	if are_credentials_good:
		play_login_success_animation()
	elif is_valid_email_address(_email_line.text):
		play_login_error_animation()
	else:
		play_email_denied_animation()


func _on_EmailLineEdit_text_changed(new_string: String) -> void:
	var is_email_valid := not new_string.empty() and is_valid_email_address(new_string)
	var style := STYLE_FOCUS if is_email_valid else STYLE_ERROR
	_email_line.set("custom_styles/focus", style)


func play_login_success_animation():
	_animator.play("CloseWindow")


func play_email_denied_animation():
	_label.set("custom_colors/font_color", Color("bd4882"))
	_label.text = "invalid email address"
	_tween.stop_all()
	_tween.interpolate_property(
		_email_line, "rect_rotation", -8, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_label,
		"rect_scale",
		Vector2.ONE * 1.1,
		_label.rect_scale,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	_tween.start()


func play_login_error_animation():
	_label.set("custom_colors/font_color", Color("bd4882"))
	_label.text = "invalid details"
	_tween.stop_all()
	_tween.interpolate_property(
		_email_line, "rect_rotation", -8, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_password_line, "rect_rotation", 8, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_label,
		"rect_scale",
		Vector2.ONE * 1.2,
		_label.rect_scale,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	_tween.start()


func _on_PasswordLineEdit_text_entered(_new_text: String) -> void:
	attempt_to_login()


func is_valid_email_address(email_address: String) -> bool:
	return email_regex.search(email_address) != null
