tool
class_name CheckmarkRevealer, "Revealer.svg"
extends Revealer

const CHECKMARK_BULLET := preload("checkmark_none.svg")
const CHECKMARK_CHECKED := preload("checkmark_valid.svg")

const COLOR_CHECKED := Color(0.239216, 1, 0.431373)

onready var _progress_icon := $ToggleBar/BarLayout/Icon as TextureRect


func mark_as_completed() -> void:
	_progress_icon.texture = CHECKMARK_CHECKED
	_progress_icon.modulate = COLOR_CHECKED


func remove_completed_mark() -> void:
	_progress_icon.texture = CHECKMARK_BULLET
	_progress_icon.modulate = Color.white


func is_completed() -> bool:
	return _progress_icon.texture == CHECKMARK_CHECKED
