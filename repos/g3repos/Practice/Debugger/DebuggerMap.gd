tool
extends DebuggerBoard

onready var player := $Player
onready var gems := $Gems
onready var player_input := $PlayerInput

var victory_screen : CanvasLayer


func _ready() -> void:
	player.connect("game_over_animation_finished", get_tree(), "reload_current_scene")
	player_input.setup(self)

	var VictoryScreenScene = load("res://Debugger/DebuggerVictoryscreen.tscn")
	victory_screen = VictoryScreenScene.instance()
	add_child(victory_screen)


func play_turn(player_direction: Vector2) -> void:
	player.move(player.current_tile + player_direction, grid_size)
	var enemies := get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.move_towards_player(player.current_tile, grid_size)
		if enemy.current_tile == player.current_tile:
			player_input.set_process(false)
			player.play_game_over_animation()
		
	if player.current_tile == gems.current_tile:
		_finish_game()


func _finish_game() -> void:
	player_input.disconnect("player_pressed", self, "play_turn")
	victory_screen.show()
