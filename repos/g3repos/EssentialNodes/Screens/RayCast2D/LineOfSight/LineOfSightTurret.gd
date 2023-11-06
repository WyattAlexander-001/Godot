extends Node2D

var found_target := false setget set_target

export var player_path: NodePath

onready var _player: Player = get_node_or_null(player_path)
onready var _raycast := $Pivot/RayCast2D
onready var _turret := $Pivot/Turret
onready var _animator: AnimationPlayer = _player.get_node("TargetAnimation")


func _process(delta: float) -> void:
	look_at(_player.global_position)
	var found_player := _raycast.get_collider() is Player
	if found_player != found_target:
		set_target(found_player)


func set_target(target: bool) -> void:
	found_target = target
	if target:
		_animator.play("highlight")
		_turret.frame = 1
	else:
		_animator.play_backwards("highlight")
		_turret.frame = 0
