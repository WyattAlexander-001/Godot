extends "res://common/Enemy3D/SmartRobot/SmartRobot3D.gd"

onready var _visiblity_notifier: VisibilityNotifier = $VisibilityNotifier


func _ready() -> void:
	_visiblity_notifier.connect("camera_entered", self, "_on_VisibilityNotifier_camera_changed", [true])
	_visiblity_notifier.connect("camera_exited", self, "_on_VisibilityNotifier_camera_changed", [false])

func _on_VisibilityNotifier_camera_changed(camera: Camera, is_visible: bool) -> void:
	if camera.is_in_group("debug_camera"):
		return
	sleeping = not is_visible
