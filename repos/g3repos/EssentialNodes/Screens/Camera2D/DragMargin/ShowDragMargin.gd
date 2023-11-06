extends CollisionShape2D

# get_parent() is not recommended, this is only meant to illustrate the drag margin's positioning
onready var camera := get_parent()


func _process(_delta: float) -> void:
	# Use global_position to prevent inheriting the player's position as it moves
	global_position = camera.get_camera_screen_center()
