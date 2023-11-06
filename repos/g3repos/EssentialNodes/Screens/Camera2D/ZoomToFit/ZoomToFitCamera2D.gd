extends Camera2D

const MIN_ZOOM := 1.0
const MAX_ZOOM := 5.0

export var player_path := NodePath()
export var enemy_path := NodePath()

onready var _player := get_node(player_path)
onready var _enemy := get_node(enemy_path)


func _physics_process(_delta: float) -> void:
	position = (_enemy.position + _player.position) / 2

	# get_viewport_rect() is one way to get the rectangle for the space being rendered.
    # It gives us access to the viewport's resolution.
	var viewport_length_squared := get_viewport_rect().size.length_squared()
    # We use the squared distance and length of vectors when possible as these operations are faster
    # than calculating the distance (which involves a square root, a complex math operation).
	var distance_squared: float = _player.position.distance_squared_to(_enemy.position)
	var ratio: float = distance_squared / viewport_length_squared

	zoom = Vector2.ONE * min(ratio + MIN_ZOOM, MAX_ZOOM)
