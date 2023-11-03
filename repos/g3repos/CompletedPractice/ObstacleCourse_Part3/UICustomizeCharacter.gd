extends Control

onready var player_1 := $PlayerCharacter
onready var player_2 := $PlayerCharacter2

onready var hand_pose_option := $Menu/HBoxContainer3/HandsPoseOption
onready var hand_color_option := $Menu/HBoxContainer2/HandsColorOption


func _ready() -> void:
	# If we're running this scene with F6, we give each character a settings
	# resource.
	#
	# The owner property is null for a scene's root node when running the scene
	# in isolation.
	if owner == null:
		player_1.settings = preload("player_1_settings.tres")
		player_2.settings = preload("player_2_settings.tres")
	else:
		# When using the menu in the obstacle course, we don't want the characters
		# to move unless the menu is visible.
		_toggle_players_active(false)

	# When selecting a new option in either drop-down menu,
	# we call _on_hands_option_changed() to update the character's look.
	hand_pose_option.connect("item_selected", self, "_on_hands_option_changed")
	hand_color_option.connect("item_selected", self, "_on_hands_option_changed")

	_connect_arrow_buttons()


func setup(savegame: SaveGame) -> void:
	player_1.settings = savegame.player_1
	player_2.settings = savegame.player_2
	_update_display()


func _on_hands_option_changed(item: int) -> void:
	var color: String = hand_color_option.text
	var pose: String = hand_pose_option.text

	# %s is a placeholder we can replace using the % sign followed by an
	# array of values.
	var filename := "hand_%s_%s.png" % [color, pose]
	# We get the directory path corresponding to this script.
	var folder_path: String = get_script().resource_path.get_base_dir()
	# And we append the "assets/" folder to it.
	folder_path = folder_path.plus_file("assets/")
	var texture_path := folder_path.plus_file(filename)

	# We prepared a function to get the selected PlayerCharacter instance in the
	# menu.
	var selected_player := _get_selected_player()
	# We then load the resource at the path we calculated and assign it to the
	# PlayerSettings.hand_texture property.
	selected_player.settings.hand_texture = load(texture_path)


# ---------
# MENU CODE
# ---------

# We use these two constants to select the appropriate drop-down button option
# given a player settings resource.
const HAND_COLORS = ["red", "blue", "yellow"]
const HAND_POSES = ["open", "closed", "point"]

# This variable keeps track of the player you selected with the white arrows.
var _player_index = 1 setget _set_player_index

onready var select_arrow := $Arrow
onready var remote_transforms := [$PlayerCharacter/RemoteTransform2D, $PlayerCharacter2/RemoteTransform2D]

onready var button_left := $Menu/HBoxContainer/SpinBox/ButtonLeft
onready var button_right := $Menu/HBoxContainer/SpinBox/ButtonRight
onready var player_index_label := $Menu/HBoxContainer/SpinBox/PlayerNumber


# All Control nodes have a show() and hide() function we can override to do
# extra stuff when making a menu visible or hiding it.
#
# Here, we prevent the characters from moving when making the menu invisible.
func show():
	.show()
	_toggle_players_active(true)


func hide():
	.hide()
	_toggle_players_active(false)


func _connect_arrow_buttons() -> void:
	button_left.connect("pressed", self, "_set_player_index", [1])
	button_right.connect("pressed", self, "_set_player_index", [2])


# Takes care of updating the menu options when changing character or initially
# loading the PlayerSettings resources.
func _update_display() -> void:
	# This first part deals with moving the white arrow between players. We use
	# a node called RemoteTransform2D to attach the arrow to a position above
	# the player.
	var selected_player := _get_selected_player()
	for remote_transform in remote_transforms:
		remote_transform.remote_path = ""
	selected_player.get_node("RemoteTransform2D").remote_path = select_arrow.get_path()

	# This code is slightly more complex than necessary to allow you to follow
	# the tutorial. When loading the player settings or selecting a different
	# player, it takes care of making the drop-down buttons match the
	# character's look.
	#
	# This kind of code can work for prototyping but we would do things
	# differently for a larger game.
	
	# At the beginning of this exercise, there is no "settings" property, so we
	# check that. Without the check, we'd get an error.
	#
	# This syntax is the same as checking for dictionary keys. It also works to
	# check for existing properties on nodes.
	if not "settings" in selected_player:
		return

	# If there are settings, we then check if there is an image. If not, we also 
	# want to exit early to avoid an error.
	var texture: Texture = selected_player.settings.get("hand_texture")
	if not texture:
		return

	# We get the file name corresponding to the character's hands texture and
	# then check if some words are in there. If so, we set the drop-down
	# button's selected index accordingly.
	var texture_filename := texture.resource_path.get_file()
	for i in HAND_COLORS.size():
		if HAND_COLORS[i] in texture_filename:
			hand_color_option.selected = i
			break

	for i in HAND_POSES.size():
		if HAND_POSES[i] in texture_filename:
			hand_pose_option.selected = i
			break


# When selecting a player with the white arrows, all we are doing is changing a
# number between 1 and 2. But to access the character's settings and update
# them, we need the actual character node.
#
# This function returns the node corresponding to a player's number.
func _get_selected_player() -> PlayerCharacter:
	var selected: PlayerCharacter = player_1
	if _player_index == 2:
		selected = player_2
	return selected


func _set_player_index(new_index: int) -> void:
	_player_index = new_index
	_update_display()
	player_index_label.text = str(_player_index)


# This function loops over the two players and activates on deactivates physics
# process on them.
func _toggle_players_active(are_active: bool) -> void:
	for player in [player_1, player_2]:
		player.set_physics_process(are_active)
