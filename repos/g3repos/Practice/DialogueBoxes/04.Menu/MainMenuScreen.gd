extends Control

# Use one of these preloaded scenes to connect buttons to the show_screen function.
const GameScene := preload("GameDemo.tscn")
const OptionsScene := preload("OptionsScreen.tscn")
const CreditsScene := preload("../03.Credits/CreditsScreen.tscn")

onready var tween := $Tween
onready var screens_container := $Screens

onready var back_button := $BackButton
onready var start_game_button := $VBoxContainer/StartGameButton
onready var options_button := $VBoxContainer/OptionsButton
onready var credits_button := $VBoxContainer/CreditsButton
onready var quit_button := $VBoxContainer/QuitButton


func _ready() -> void:
	back_button.connect("pressed", self, "empty_screens")
	start_game_button.connect("pressed", self, "show_screen", [GameScene])
	# Connect the options_button node to show the OptionsScene when pressing the
	# button. See how we connect the start_game_button above for reference.
	#
	# You'll find three preloaded scenes at the top of the script: GameScene,
	# OptionsScene, and CreditsScene. You'll need to bind them to the signal
	# callback function.
	
	# Connect the credits_button node to show the CreditsScene when pressing the
	# button.

	# Connect the quit_button to the SceneTree so pressing the button quits the game.
	# You can get the SceneTree by calling get_tree().



func show_screen(scene: PackedScene) -> void:
	var screen := scene.instance()
	screens_container.add_child(screen)
	screen.rect_pivot_offset = screen.rect_size / 2
	tween.interpolate_property(
		screen,
		"rect_position:x",
		-get_viewport_rect().size.x,
		0,
		1,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT
	)
	tween.start()
	back_button.show()


func empty_screens() -> void:
	back_button.hide()
	for child in screens_container.get_children():
		child.free()
