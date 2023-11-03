extends RigidBody2D

onready var drag_area := $DragArea


func _ready() -> void:
	drag_area.connect("requested_move", self, "_on_DragArea_requested_move")


func _on_DragArea_requested_move(impulse: Vector2) -> void:
	# apply the impulse here
	pass
