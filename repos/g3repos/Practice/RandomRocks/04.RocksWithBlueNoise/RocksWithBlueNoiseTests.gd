extends PracticeTests

var child_count := 0

const ROWS := 10
const COLUMNS := 10


func _init() -> void:
	add_requirement(".", [], ["add_rocks_with_blue_noise"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(0.5), "timeout")

	scene_root.add_rocks_with_blue_noise(COLUMNS, ROWS)
	child_count = scene_root.get_child_count()


func test_function_generates_the_expected_100_rocks() -> String:
	if child_count != 100:
		return tr(
			"We expected the function to generate 100 rocks but got %s instead." % child_count
		)
	return ""


func test_each_rock_fits_in_a_grid_cell() -> String:
	var x := 0
	var y := 0
	var cell_size: Vector2 = scene_root.CELL_SIZE

	var rocks_with_same_offset_count := 0
	var last_offset := Vector2.ZERO

	for rock in scene_root.get_children():
		var cell := Vector2(y, x)
		var rock_size: Vector2 = rock.texture.get_size() * rock.scale
		var max_offset := cell_size - rock_size

		var min_position := cell * cell_size
		var max_position: Vector2 = min_position + max_offset

		if rock.position > max_position or rock.position < min_position:
			return (
				tr(
					"We found a rock that was outside of its grid cell. Its position should be between %s and %s, but it is at %s instead."
				)
				% [min_position, max_position, rock.position]
			)

		var rock_offset: Vector2 = rock.position - min_position
		if last_offset.distance_to(rock_offset) < 0.1:
			rocks_with_same_offset_count += 1
		else:
			rocks_with_same_offset_count = 0

		last_offset = rock_offset
		if rocks_with_same_offset_count == 10:
			return tr(
				"It seems that rocks are not offset randomly. Did you add random_offset to each rock's position?"
			)

		x = (x + 1) % 10
		if x == 0:
			y += 1

	return ""
