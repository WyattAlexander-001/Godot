extends Polygon2D

export var cannonball_scene: PackedScene

onready var _pivot := $Pivot
onready var _fire_point := $Pivot/Barrel/FirePoint
onready var _animation_player := $AnimationPlayer


func _process(_delta: float) -> void:
	_pivot.look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("throw_ball"):
		fire_cannonball(get_global_mouse_position())


func fire_cannonball(target_position: Vector2) -> void:
	if _animation_player.is_playing():
		return

	_animation_player.play("fire")

	var cannonball = cannonball_scene.instance()

	cannonball.direction = _pivot.global_position.direction_to(target_position)
	cannonball.position = _fire_point.global_position
	_pivot.add_child(cannonball)
