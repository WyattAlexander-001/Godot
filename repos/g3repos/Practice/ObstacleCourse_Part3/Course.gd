extends YSort

const ROCKS := [
	preload("obstacles/rocks/Rock1.tscn"),
	preload("obstacles/rocks/Rock2.tscn"),
	preload("obstacles/rocks/Rock3.tscn"),
]

onready var mask: TileMap = $Mask


func _ready() -> void:
	randomize()
	add_rocks_on_grid()
	mask.visible = false


func get_random_rock() -> Sprite:
	var rock_random_index := randi() % ROCKS.size()
	return ROCKS[rock_random_index].instance()


func add_rocks_on_grid() -> void:
	for cell in mask.get_used_cells():
		var rock := get_random_rock()
		add_child(rock)
		var rock_size := rock.scale * rock.texture.get_size()
		var available_space := mask.cell_size - rock_size
		var random_offset := Vector2(randf(), randf()) * available_space
		rock.position = mask.position + mask.map_to_world(cell) + random_offset
