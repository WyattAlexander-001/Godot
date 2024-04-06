extends Node3D

@export var rotation_speed = 11.0
@export var rotation_axis = Vector3(1, 0, 0) # Default rotation around the X-axis.
@onready var thing = $"." #Root Node, simply ctrl+mouse click drag and drop


func _process(delta):
	var angle = rotation_speed * delta
	thing.rotate_object_local(rotation_axis.normalized(), angle)
