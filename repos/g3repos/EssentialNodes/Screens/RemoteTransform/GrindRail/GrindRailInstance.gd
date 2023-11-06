extends Area

onready var _remote: RemoteTransform = $Path/PathFollow/RemoteTransform
onready var _particles: Particles = $Path/PathFollow/Particles
onready var _path_follow: PathFollow = $Path/PathFollow
onready var _tween: Tween = $Tween
onready var _path: Path = $Path

func _ready() -> void:
	connect("body_entered", self, "grind_rail")


func grind_rail(player: Player3D) -> void:
	# Disable the player and start the grinding particles.
	player.set_physics_process(false)
	player.grind(true)
	_particles.emitting = true
	# Store the player position and set the PathFollow's offset to the closest position possible.
	var local_player_position: Vector3 = _path.to_local(
		player.global_transform.origin
	)
	_path_follow.offset = _path.curve.get_closest_offset(local_player_position)
	# Move the player in the direction they are farthest from and update the direction of particles to match.
	var target := int(_path_follow.unit_offset < 0.5)
	_remote.remote_path = player.get_path()
	# Animate the path follow taking the player to the other end.
	_tween.interpolate_property(
		_path_follow, "unit_offset", _path_follow.unit_offset, target, 1.5
	)
	_tween.start()
	yield(_tween, "tween_all_completed")

	# When the tween ends, disable the remote transform, turn off the particles and re-enable the player.
	_remote.remote_path = ""
	_particles.emitting = false
	player.set_physics_process(true)
	player.grind(false)
