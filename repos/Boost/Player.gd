extends RigidBody3D


@export_range(0,2000) var thrust : float = 1000.0
@export_range(0,200) var torque : float = 100.0
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
		apply_central_force(basis.y * delta * thrust)
	elif Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0,torque) * delta)
	elif Input.is_action_pressed("rotate_right"):
		#rotate_z(-delta * 2)
		apply_torque(Vector3(0.0,0.0,-torque) * delta)


func _on_body_entered(body: Node) -> void:
	print(body.name)
	if "Start" in body.get_groups():
		print("You are at the starting platform")
	elif "Goal" in body.get_groups():
		complete_level(body.file_path)
	elif "Hazard" in body.get_groups():
		crash_sequence()

func crash_sequence() -> void:
	print("YOU CRASHED!")
	get_tree().reload_current_scene() # Gives access to other funcs

func complete_level(next_level_file: String) -> void:
	print("You WIN!!!")
	#get_tree().quit() # Good for ending game....
	get_tree().change_scene_to_file(next_level_file)
	
