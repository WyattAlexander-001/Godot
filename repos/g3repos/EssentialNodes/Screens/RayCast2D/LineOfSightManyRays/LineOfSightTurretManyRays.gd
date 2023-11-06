tool
extends Node2D

export var player_path := NodePath()

export var vision_range := 600.0
export var rays_angle_interval := deg2rad(3.0)
export var rays_amount := 3

var _has_target := false setget _set_has_target

onready var _player := get_node_or_null(player_path)
onready var _animator: AnimationPlayer = _player.get_node("TargetAnimation")
onready var _turret: AnimatedSprite = $Pivot/Turret
onready var _pivot: Node2D = $Pivot


# We create multiple rays to give the AI a cone of vision.
func _ready() -> void:
	_create_rays()

	if Engine.editor_hint:
		set_physics_process(false)


func _physics_process(_delta: float) -> void:
	_pivot.look_at(_player.global_position)
	var found_player := false
	for ray in _pivot.get_children():
		if ray is RayCast2D and ray.is_colliding():
			found_player = ray.get_collider().is_in_group("player")
			if found_player:
				break

	if found_player != _has_target:
		_set_has_target(found_player)


func _create_rays() -> void:
	for ray_offset in range(-rays_amount / 2, rays_amount / 2 + 1):
		var angle: float = ray_offset * rays_angle_interval
		var raycast := RayCast2D.new()
		raycast.cast_to = Vector2.RIGHT.rotated(angle) * vision_range
		raycast.add_to_group("Draw")
		raycast.enabled = true
		# Targets layer 1: player and layer 3: environment (bit 3)
		raycast.collision_mask = 1 + 4
		_pivot.add_child(raycast)


func _set_has_target(has_target: bool) -> void:
	_has_target = has_target
	if has_target:
		_animator.play("highlight")
		_turret.frame = 1
	else:
		_animator.play_backwards("highlight")
		_turret.frame = 0
