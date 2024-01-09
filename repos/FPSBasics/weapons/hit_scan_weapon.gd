extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh : Node3D

@onready var cool_down_timer = $CoolDownTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cool_down_timer.is_stopped():
			shoot()

func shoot() -> void:
	cool_down_timer.start(1.0/fire_rate)
	print("weapon fired")
	weapon_mesh.position.z += recoil
