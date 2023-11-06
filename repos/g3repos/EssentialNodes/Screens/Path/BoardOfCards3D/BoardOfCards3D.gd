extends Spatial

## Holds the position of the slots where the cards will be moved.
var slot_positions := []

onready var _slots: Spatial = $Slots
onready var _hand: Spatial = $Hand


func _ready() -> void:
	for node in _slots.get_children():
		slot_positions.push_front(node.translation)

	for node in _hand.get_children():
		node.setup(slot_positions)
