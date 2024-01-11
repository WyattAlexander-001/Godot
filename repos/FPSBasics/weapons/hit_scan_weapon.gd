extends Node3D

@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh : Node3D
@export var weapon_damage := 15.0
@export var muzzle_flash : GPUParticles3D
@export var sparks: PackedScene
@export var automatic : bool

@onready var cool_down_timer = $CoolDownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d = $RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if automatic == true:
		if Input.is_action_pressed("fire"):
			if cool_down_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cool_down_timer.is_stopped():
				shoot()		
		
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position,delta * 10.0)

func shoot() -> void:
	muzzle_flash.restart()
	cool_down_timer.start(1.0/fire_rate)
	var collider = ray_cast_3d.get_collider()
	printt("weapon fired", collider)
	weapon_mesh.position.z += recoil
	if collider is Enemy:
		collider.hitpoints -= weapon_damage
	var spark = sparks.instantiate()
	add_child(spark)
	spark.global_position = ray_cast_3d.get_collision_point()

