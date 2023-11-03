class_name DebuggerEnemy
extends DebuggerActor


# AI logic: prioritize following the player in the X axis, then follow him on the Y axis.
func move_towards_player(player_tile: Vector2, grid_size: Vector2) -> void:
	var direction = Vector2.ZERO
	if player_tile.x < current_tile.x:
		direction.x = -1
	elif player_tile.x > current_tile.x:
		direction.x = 1

	if player_tile.y < current_tile.y:
		direction.y = -1
	elif player_tile.y > current_tile.y:
		direction.y = 1

	move(current_tile + direction, grid_size)
