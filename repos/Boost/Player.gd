extends RigidBody3D


@export_range(0,2000) var thrust : float = 1000.0
@export_range(0,200) var torque : float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio # hold ctrl and click/drag


var is_transitioning: bool = false
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
	if Input.is_action_pressed("boost"):
		print("Spacebar pressed")
		count+=1
		print(count)
		apply_central_force(basis.y * delta * thrust)
	elif Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0,torque) * delta)
	elif Input.is_action_pressed("rotate_right"):
		#rotate_z(-delta * 2)
		apply_torque(Vector3(0.0,0.0,-torque) * delta)


func _on_body_entered(body: Node) -> void:
	print(body.name)
	if is_transitioning == false:
		if "Start" in body.get_groups():
			print("You are at the starting platform")
		elif "Goal" in body.get_groups():
			complete_level(body.file_path)
		elif "Hazard" in body.get_groups():
			crash_sequence()

func crash_sequence() -> void:
	print("YOU CRASHED! We Wait 1 Second And Then Reload")
	explosion_audio.play()
	var tween = create_tween()
	set_process(false) #disables process function so we can't control ship
	is_transitioning =true
	tween.tween_interval(2.5) #the audio is 2.5 seconds long, so wait 2.5 before reloading (hacky)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	print("You WIN!!!")
	var tween = create_tween()
	set_process(false) #disables process function so we can't control ship
	is_transitioning =true
	tween.tween_interval(1.0)
	#get_tree().quit() # Good for ending game....
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
