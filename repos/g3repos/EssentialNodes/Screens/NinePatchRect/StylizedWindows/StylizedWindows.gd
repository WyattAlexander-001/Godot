extends MarginContainer

export (int) var drag_size := 12

## Helps the user move the windows further with less mouse motion
const MINIMUM_DRAG = 2

## Remembers which dragger panel was last clicked.
var _dragging: String = "none"

onready var _draggers: MarginContainer = $Draggers
onready var _close: Button = $PanelContainer/VBoxContainer/Toolbar/Close
onready var _ok: Button = $PanelContainer/VBoxContainer/Buttons/Ok
onready var _cancel: Button = $PanelContainer/VBoxContainer/Buttons/Cancel


func _ready() -> void:
	for child in _draggers.get_children():
		# Increasing the dragger min size creates a larger area to grab the window.
		child.rect_min_size = Vector2(drag_size, drag_size)
		# Process their gui_input signals in a callback function, and pass the node
		# reference as a bind.
		child.connect("gui_input", self, "_forwarded_gui_input", [child])
	
	# For this demonstration, all buttons perform the same action.
	# You can connect them to their own callback signals to extend their abilities.
	_ok.connect("pressed", self, "queue_free")
	_close.connect("pressed", self, "queue_free")
	_cancel.connect("pressed", self, "queue_free")


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_action_pressed("click"):
		# Move the window if this node recieves any direct gui inputs.
		rect_position += event.relative


## Interprets the gui_input signals of dragger nodes, and adjusts the window margins
# depending on which dragger was grabbed.
func _forwarded_gui_input(event: InputEvent, dragger: Control) -> void:
	if event is InputEventMouseButton:
		_dragging = dragger.name if event.pressed else "none"
	if event is InputEventMouseMotion:
		var base_drag: Vector2 = event.relative.normalized() * MINIMUM_DRAG
		if "Left" in _dragging:
			margin_left += event.relative.x + base_drag.x
		elif "Right" in _dragging:
			margin_right += event.relative.x + base_drag.x
		if "Top" in _dragging:
			margin_top += event.relative.y + base_drag.y
		elif "Bottom" in _dragging:
			margin_bottom += event.relative.y + base_drag.y
