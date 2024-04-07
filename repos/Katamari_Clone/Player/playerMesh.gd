extends MeshInstance3D

@export var rotation_speed = 11.0
var initial_rotation = Quaternion()
var rotation_axis = Vector3.ZERO
@onready var thing = $"." 

@onready var camera = $"../TwistPivot/PitchPivot/Camera3D"

func _ready():
	# Capture the initial orientation
	initial_rotation = thing.global_transform.basis.get_rotation_quaternion()

func _process(delta):
	rotation_axis = Vector3.ZERO  # Reset each frame

	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_back"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	# Normalize to handle diagonal movement correctly
	input_vector = input_vector.normalized()

	# Convert the input vector into a 3D vector in the world space, relative to the camera's orientation
	var forward_dir = camera.global_transform.basis.z.normalized() * -1
	var right_dir = camera.global_transform.basis.x.normalized()
	var world_input_dir = forward_dir * input_vector.y + right_dir * input_vector.x

	if world_input_dir.length() > 0:
		var target_rotation = Quaternion(Vector3(0, 1, 0), world_input_dir.angle_to(Vector3(0, 0, -1)))
		thing.global_transform.basis = Basis(target_rotation).slerp(thing.global_transform.basis, rotation_speed * delta)
	else:
		# Reset to initial orientation if there's no input
		thing.global_transform.basis = Basis(initial_rotation)
#
