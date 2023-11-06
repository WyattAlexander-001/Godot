extends Node2D

export var bullet_scene: PackedScene
export var noise: OpenSimplexNoise

var spray_angle_range := PI / 16.0

onready var _timer: Timer = $Timer


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	if not _timer.is_stopped():
		return

	_timer.start()

	var spray_rotation = spray_angle_range * noise.get_noise_1d(OS.get_ticks_msec())
	var shoot_vector = Vector2.UP.rotated(global_rotation + spray_rotation)
	var bullet = bullet_scene.instance()

	add_child(bullet)
	bullet.direction = shoot_vector
	bullet.position = global_position
