extends Node2D

## Holds the position of the slots where the cards will be moved.
var slot_positions := []

onready var _slots: HBoxContainer = $Slots
onready var _hand: Node2D = $Hand


func _ready() -> void:
	for node in _slots.get_children():
		slot_positions.push_front(
			_slots.rect_position + node.rect_position + node.rect_pivot_offset
		)

	for node in _hand.get_children():
		node.setup(slot_positions)
