extends Node2D

export var bullet_scene: PackedScene


func fire():
	var direction := Vector2.UP.rotated(global_rotation)
	var bullet = bullet_scene.instance()
	bullet.position = global_position
	bullet.rotation = global_rotation
	bullet.direction = direction
	add_child(bullet)
