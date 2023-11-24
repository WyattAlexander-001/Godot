extends RigidBody3D

# Exported Variables
@export_range(0,2000) var thrust : float = 1000.0
@export_range(0,200) var torque : float = 100.0

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio # hold ctrl and click/drag
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


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
		print("Spacebar pressed boost INPUT")
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
		count+=1
		print(count)
		apply_central_force(basis.y * delta * thrust)
	else:
		rocket_audio.stop()
		booster_particles.emitting = false
		
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0,0.0,torque) * delta)
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_right"):
		#rotate_z(-delta * 2)
		apply_torque(Vector3(0.0,0.0,-torque) * delta)
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false
		
	if Input.is_action_just_pressed("ui_cancel"): # just pressed is one press "esc"
		get_tree().quit()
		


# Player Body Touching A node with special GROUP NAME
func _on_body_entered(body: Node) -> void:
	print(body.name)
	if is_transitioning == false:
		if "Start" in body.get_groups(): # only one start pad per level
			print("You are at the starting platform")
		elif "Goal" in body.get_groups(): # Only one goal for level
			complete_level(body.file_path)
		elif "Hazard" in body.get_groups(): # Alot of Nodes will be hazard for difficulty
			crash_sequence()

func crash_sequence() -> void:
	print("YOU CRASHED! We Wait 1 Second And Then Reload")
	explosion_particles.emitting = true
	explosion_audio.play()
	var tween = create_tween()
	set_process(false) #disables process function so we can't control ship
	is_transitioning =true
	tween.tween_interval(2.5) #the audio is 2.5 seconds long, so wait 2.5 before reloading (hacky)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	print("You WIN!!!")
	success_particles.emitting = true
	success_audio.play()
	var tween = create_tween()
	set_process(false) #disables process function so we can't control ship
	is_transitioning =true
	tween.tween_interval(2.9)
	#get_tree().quit() # Good for ending game....
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
	
	# ===================== Code Consolation:
	

		
