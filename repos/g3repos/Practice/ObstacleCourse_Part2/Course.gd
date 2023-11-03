extends YSort


const ROCKS := [
	preload("obstacles/rocks/Rock1.tscn"),
	preload("obstacles/rocks/Rock2.tscn"),
	preload("obstacles/rocks/Rock3.tscn"),
]

onready var mask: TileMap = $Mask


func _ready() -> void:
	randomize()
	add_rocks_on_mask_with_blue_noise()
	mask.queue_free()


func add_rocks_on_mask_with_blue_noise() -> void:
	for cell in mask.get_used_cells():
		var offset := mask.position + mask.map_to_world(cell)
		var rock := get_random_rock()
		add_child(rock)

		var rock_size := rock.scale * rock.texture.get_size()
		var random_offset := calculate_random_variation(mask.cell_size - rock_size)
		rock.position = offset + random_offset


func get_random_rock() -> Sprite:
	var rock_random_index := randi() % ROCKS.size()
	return ROCKS[rock_random_index].instance()


func calculate_random_variation(size: Vector2) -> Vector2:
	return Vector2(randf(), randf()) * size
