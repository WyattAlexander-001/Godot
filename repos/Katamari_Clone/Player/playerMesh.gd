extends MeshInstance3D

@export var rotation_speed = 11.0
var initial_rotation = Quaternion()  # Default orientation as a quaternion.
var rotation_axis = Vector3.ZERO  # Dynamically changed rotation axis, reset each frame.
@onready var thing = $"."

func _ready():
	# Capture the initial orientation in quaternion format for accurate resetting.
	initial_rotation = thing.global_transform.basis.get_rotation_quaternion()

func _process(delta):
	rotation_axis = Vector3.ZERO  # Assume no rotation by default each frame.
	
	# Determine the rotation axis based on current input.
	if Input.is_action_pressed("move_forward"):
		rotation_axis = Vector3(-1, 0, 0)  # Rotate around X-axis (nod down).
	elif Input.is_action_pressed("move_back"):
		rotation_axis = Vector3(1, 0, 0)   # Rotate around X-axis (nod up).
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		rotation_axis = Vector3(0, 0, 1 if Input.is_action_pressed("move_left") else -1)  # Rotate around Z-axis.

	# Apply rotation based on the determined axis.
	if rotation_axis != Vector3.ZERO:
		var angle = rotation_speed * delta
		thing.rotate_object_local(rotation_axis.normalized(), angle)
	else:
		# If no input and the object was rotating, reset to the initial orientation.
		thing.global_transform.basis = Basis(initial_rotation)
