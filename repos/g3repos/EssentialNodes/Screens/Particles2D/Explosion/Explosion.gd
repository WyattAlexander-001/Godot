extends Node2D

onready var explosion_spawner := $ExplosionSpawner


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		explosion_spawner.global_position = get_global_mouse_position()
		explosion_spawner.spawn()
