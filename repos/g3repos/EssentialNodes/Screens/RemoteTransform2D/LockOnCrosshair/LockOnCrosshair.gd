extends Node2D

onready var _crosshair_path := $Crosshair.get_path()
onready var _crosshair_animation := $Crosshair/AnimationPlayer

onready var _mouse_area: Area2D = $MouseFollow
onready var _mouse_area_remote := $MouseFollow/RemoteTransform2D


func _ready() -> void:
	_mouse_area.connect("body_entered", self, "lock_onto_enemy")


func _process(_delta: float) -> void:
	_mouse_area.set_position(get_local_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_crosshair"):
		reset_crosshair()


func lock_onto_enemy(body: Node) -> void:
	if body.is_in_group("enemy") and not body.enemy_remote.remote_path:
		reset_remote_paths()
		# Give the enemy's remote the crosshair's path. This moves the crosshair to the enemy.
		body.enemy_remote.remote_path = _crosshair_path
		_crosshair_animation.stop(true)
		_crosshair_animation.play("lock_on")


func reset_crosshair() -> void:
	reset_remote_paths()
	_mouse_area_remote.remote_path = _crosshair_path
# Stop and reset the animation so lock_off starts over if it has to play again.
	_crosshair_animation.stop(true)
	_crosshair_animation.play("lock_off")


func reset_remote_paths() -> void:
	for remote_node in get_tree().get_nodes_in_group("remote"):
		remote_node.remote_path = ""
