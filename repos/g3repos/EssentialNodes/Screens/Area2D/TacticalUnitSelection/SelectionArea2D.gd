## Draws selection boxes and detects when you select one or multiple units at once.
extends Area2D

# The following constants are for drawing.
const SELECTION_OUTLINE_WIDTH := 4.0
const SELECTION_COLOR := Color(0.301961, 0.65098, 1)

# This represents our selection rectangle. We use it to draw the selection and
# update the area's shape.
var selection_rect := Rect2(Vector2.ZERO, Vector2.ZERO)
# When the player releases the mouse, we store the selection in this array.
var selected_units := []
## Distance threshold in pixels beyond which we start a box selection and select
## multiple units.
var box_selection_distance_threshold := 3.0
## The list of selectable entities that overlap the selection rectangle.
var _detected_units := []

onready var _collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# We use processing to update the box selection every frame, which we don't
	# want to do by default.
	set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and monitoring:
		cancel_selection()

	if not event.is_action("click"):
		return

	# We start and end the selection process by toggling the monitoring property.
	if event.is_action_pressed("click"):
		start_selection(event.position)
	elif event.is_action_released("click"):
		end_selection(event.position)
	update()
	get_tree().set_input_as_handled()


func _process(delta: float) -> void:
	# When a selection is active, we update the rectangle every frame as well as
	# the area's rectangle collision shape.
	selection_rect.end = get_local_mouse_position()
	_collision_shape.shape.extents = selection_rect.size / 2.0
	_collision_shape.position = selection_rect.position + _collision_shape.shape.extents

	# The area detects all overlapping units for us.
	_detected_units = get_overlapping_areas()
	# If the player only clicks, they want to select a single unit. We compare
	# the selection box's length to a threshold to detect that.
	if selection_rect.size.length() < box_selection_distance_threshold and _detected_units:
		select_top_node(_detected_units)
	else:
		selected_units = _detected_units
	update()


func _draw() -> void:
	# This condition clears the selection rectangle as soon as the player
	# releases the mouse button.
	if monitoring:
		draw_rect(selection_rect, SELECTION_COLOR, false, SELECTION_OUTLINE_WIDTH)

	# We draw a rectangle around every unit.
	for unit in selected_units:
		draw_rect(
			Rect2(unit.position, Vector2.ZERO).grow(100.0),
			SELECTION_COLOR,
			false,
			SELECTION_OUTLINE_WIDTH
		)


func start_selection(mouse_position: Vector2) -> void:
	selection_rect.position = mouse_position
	_toggle_selection_state(true)


func end_selection(mouse_position: Vector2) -> void:
	selection_rect.end = mouse_position
	_toggle_selection_state(false)
	if _detected_units and selection_rect.size.length() < box_selection_distance_threshold:
		select_top_node(_detected_units)


func cancel_selection() -> void:
	_toggle_selection_state(false)
	selected_units.clear()


func select_top_node(nodes: Array) -> void:
	nodes.sort_custom(self, "_sort_by_tree_order")
	selected_units = [nodes[0]]


func _sort_by_tree_order(a, b) -> bool:
	return a.get_position_in_parent() > b.get_position_in_parent()


func _toggle_selection_state(value: bool) -> void:
	monitoring = value
	set_process(monitoring)
