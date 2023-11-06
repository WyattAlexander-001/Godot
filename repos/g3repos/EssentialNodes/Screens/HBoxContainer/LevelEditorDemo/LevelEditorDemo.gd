extends Node2D

onready var PaintCursorTexture := preload("res://common/VFX/LaserBeam2D/glowing_circle.png")
onready var EraseCursorTexture := preload("res://common/blackhole.png")

## -1 clears a cell. Tileset 0 is the only one assigned to the Tilemap.
const MODES := {"paint": 0, "erase": -1}

## Positions surrounding the clicked cell are painted in a 3x3 square around the cursor.
const SURROUNDING_CELLS := [
	Vector2(-1, 1),
	Vector2.DOWN,
	Vector2(1, 1),
	Vector2.LEFT,
	Vector2.ZERO,
	Vector2.RIGHT,
	Vector2(-1, -1),
	Vector2.UP,
	Vector2(1, -1),
]

# This integer determines which tile to use on a cell. We get it from the MODES
# constant, after reading Button text as a key.
var _current_mode := 0

onready var _tilemap: TileMap = $TileMap
# Holds the top bar of buttons and control nodes. We iterate through its children
# to find buttons to connect.
onready var _toolbox: HBoxContainer = $CanvasLayer/MarginContainer/Toolbox

# Limits how many tiles we can paint onto the grid before we have to erase some.
onready var _editor_capacity_bar: ProgressBar = $CanvasLayer/MarginContainer/Toolbox2/EditorCapacityBar
onready var _mouse_cursor: Sprite = $MouseCursor


func _ready() -> void:
	for node in _toolbox.get_children():
		if node is Button:
			node.connect("pressed", self, "update_painting_mode", [node.text])


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		paint_cells(get_global_mouse_position())

	if event is InputEventMouseMotion:
		_mouse_cursor.position = event.position


## paints cells in a 3x3 cell grid based on an input position.
func paint_cells(cell_position: Vector2) -> void:
	var is_map_full := _editor_capacity_bar.get_as_ratio() == 1.0
	if is_map_full and _current_mode == MODES["paint"]:
		return

	var cell := _tilemap.world_to_map(cell_position)
	
	# Cycle through the 3x3 grid of cells to paint.
	for offset in SURROUNDING_CELLS:
		var offset_cell: Vector2 = cell + offset
		var previous_state := _tilemap.get_cellv(offset_cell)

		# Paint the cell using the value in the modes selection.
		_tilemap.set_cellv(offset_cell, _current_mode)

		# Apply the autotiling rules for the cell.
		_tilemap.update_bitmask_area(offset_cell)
	
		if previous_state != _current_mode:
			adjust_capacity_bar()


## Sets the bar's value based on number of occupied cells in the TileMap.
func adjust_capacity_bar() -> void:
	_editor_capacity_bar.value = _tilemap.get_used_cells().size()


## Updates the current mode and mouse cursor based on the pressed button.
func update_painting_mode(key: String) -> void:
	# Ensure we're assinging the _current_mode to something in the MODES dictionary.
	assert(key.to_lower() in MODES)
	_current_mode = MODES[key.to_lower()]
	_mouse_cursor.texture = PaintCursorTexture if _current_mode == MODES["paint"] else EraseCursorTexture
	_mouse_cursor.scale = Vector2(2.0, 2.0) if _current_mode == MODES["paint"] else Vector2(1.0, 1.0)
