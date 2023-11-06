extends Node2D

export var spray_scene: PackedScene
export var noise: OpenSimplexNoise

var spray_angle_range := PI / 8.0
var min_range := 500.0
var max_range := 750.0

onready var _timer: Timer = $Timer
onready var _ray: RayCast2D = $RayCast2D


func _ready() -> void:
	randomize()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	if not _timer.is_stopped():
		return

	_timer.start()

	var spray_rotation = spray_angle_range * noise.get_noise_1d(OS.get_ticks_msec())
	var shoot_vector = Vector2.UP.rotated(spray_rotation) * rand_range(min_range, max_range)
	var spray = spray_scene.instance()

	add_child(spray)
	_ray.cast_to = shoot_vector
	_ray.force_raycast_update()
	if _ray.is_colliding():
		spray.setup(global_position, _ray.get_collision_point())
		spray.hit(_ray.get_collision_point(), _ray.get_collision_normal())
	else:
		spray.setup(global_position, to_global(shoot_vector))
