extends Spatial

const ZOOM_MIN_DISTANCE := -6.0
const ZOOM_MAX_DISTANCE := -12.0

var _target_zoom := ZOOM_MIN_DISTANCE

onready var _panel_container := $Nametag/Viewport/PanelContainer
onready var _nametag_label := $Nametag/Viewport/PanelContainer/Label
onready var _pivot: Spatial = $CameraOrigin
onready var _camera: Camera = $CameraOrigin/Camera


func _process(delta: float) -> void:
	_pivot.rotate_y(delta / 2.0)
	_camera.translation.z = lerp(_camera.translation.z, _target_zoom, delta)

func _on_LineEdit_text_changed(new_text: String) -> void:
	_nametag_label.text = new_text

func _on_Zoom_toggled(button_pressed: bool) -> void:
	_target_zoom = ZOOM_MIN_DISTANCE if not button_pressed else ZOOM_MAX_DISTANCE

## Make the Panel match the Label's bounds if the Label expands/shrinks past the Panel.
func _on_PanelContainer_sort_children():
	_panel_container.rect_size.y = 0
