extends Node

# This is the template for our screenshot filenames:
#
# - %s is a placeholder to print variables as-is.
# - %02d takes a number and ensure adds leading a leading zero as necessary to
#   ensure there are always 2 digits.
#
# Example output filename: "Node_Essentials_2021-06-19_10-40-00.png"
const FILENAME_TEMPLATE := "%s_%s-%02d-%02d_%02d-%02d-%02d"

# Our Godot project's name, which we store to add in screenshot file names.
onready var game_name: String = ProjectSettings.get_setting("application/config/name")

onready var _anim_player := $CanvasLayer/AnimationPlayer
onready var _label := $CanvasLayer/Label


func _unhandled_input(event: InputEvent) -> void:
	# We set this action to F9 in our project.
	if event.is_action_pressed("take_screenshot"):
		take_screenshot()
	# And we mapped this action to F10.
	if event.is_action("open_user_directory"):
		open_user_directory()

## Generates an image name, gets the Viewport data, and saves it as a png file in
## the user folder.
func take_screenshot() -> void:
	var date: Dictionary = OS.get_datetime()
	var image_name = (
		FILENAME_TEMPLATE % [
			game_name,
			date["year"],
			date["month"],
			date["day"],
			date["hour"],
			date["minute"],
			date["second"]
		]
	)
	# We get the root viewport's texture data to save it as an image file. The
	# function returns the rendered pixels.
	var image: Image = get_viewport().get_texture().get_data()
	# In OpenGL images render mirrored vertically.
	#
	# Godot automatically flips images when displaying them on your screen, but
	# here, we need to do it manually.
	image.flip_y()
	# And finally, we save the screenshot to the user's directory using the
	# image's save_png() method.
	image.save_png("user://%s.png" % [image_name])
	# We display a label to notify the player we saved a screenshot.
	_label.text = "Screenshot taken: \"%s\"" % [image_name]
	_anim_player.stop(true)
	_anim_player.play("fade")

## Opens the user:// folder. This code works on all supported platforms.
func open_user_directory() -> void:
	OS.shell_open(OS.get_user_data_dir())
