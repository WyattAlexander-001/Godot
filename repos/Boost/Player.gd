extends RigidBody3D


# Called when the node enters the scene tree for the first time.
var count: int = 0
func _ready() -> void:
	var faveNumber: float = 42
	print("\tHello World")
	print("Don't Panic\n\n")
	print(50 + faveNumber)
	# print("50" + faveNumber) //There is no type coercion
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("boost"):
		#position.y = position.y + 2 # y does go up in 3D!
		print("Spacebar pressed")
		count+=1
		print(count)
	elif Input.is_action_just_pressed("ui_focus_next"):
		#position.y = position.y - 2
		print("tab pressed boi!")
		
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta *1000.0)
	elif Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0,100.0) * delta)
	elif Input.is_action_pressed("rotate_right"):
		#rotate_z(-delta * 2)
		apply_torque(Vector3(0.0,0.0,-100.0) * delta)


func _on_body_entered(body: Node) -> void:
	print(body.name)
