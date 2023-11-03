extends Node2D

const GEMS := [
	preload("gems/gems_blue_1.png"),
	preload("gems/gems_blue_2.png"),
	preload("gems/gems_blue_3.png"),
	preload("gems/gems_blue_4.png"),
	preload("gems/gems_blue_5.png"),
	preload("gems/gems_mixed_2.png"),
]
# Maximum angle applied to a gem clockwise or counterclockwise.
const MAX_ANGLE := PI / 4.0

var gems_count := GEMS.size()


func calculate_random_position(max_offset: Vector2) -> Vector2:
	# Complete this function to return a random position, with a maximum output 
	# value of `max_offset`.
	return Vector2(0, 0)


# Generates `count` gems, placing them at random, even if some overlap.
func generate_gems_at_random_positions(count: int, max_offset: Vector2) -> void:
	for i in range(count):
		var gem := Sprite.new()
		gem.texture = GEMS[randi() % gems_count]
		add_child(gem)
		gem.position = calculate_random_position(max_offset)
		gem.rotation = randf() * MAX_ANGLE * 2.0 - MAX_ANGLE
