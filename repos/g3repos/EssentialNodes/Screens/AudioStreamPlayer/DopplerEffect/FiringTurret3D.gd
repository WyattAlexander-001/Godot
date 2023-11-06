extends "res://common/Turret3D/LineOfSightTurret3D.gd"

export(PackedScene) var projectile_scene

onready var _timer: Timer = $Timer
onready var _rockets: Array = $Pivot/TurretModel/Rockets.get_children()


func _process(delta: float) -> void:
	if is_targetting and _timer.is_stopped():
		fire()


func fire() -> void:
	_timer.start()

	var projectile: Area = projectile_scene.instance()
	projectile.direction = _raycast.cast_to.normalized()
	
	_raycast.add_child(projectile)
	
	# Move the ray to the next rocket.
	_rockets.push_back(_rockets.pop_front())
	_raycast.global_transform = _rockets.front().global_transform
