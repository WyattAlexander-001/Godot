# By convention, we place the tool keyword at the top of the script, before the
# extends line.
tool
extends Area2D


# The duration the linked door stays open in seconds.
export(float, 0.0, 100.0) var open_time := 1.0

onready var timer := $Timer
onready var line := $Line2D
# We'll add a door as a child of each PressurePlate instance in the obstacle
# course.
onready var door := $Door
onready var animation_player := $AnimationPlayer
onready var door_animation_player := $Door/AnimationPlayer


func _ready() -> void:
	timer.wait_time = open_time
	# We update the line's points to draw an L-shaped line between the pressure
	# plate and the door.
	line.points = [
		# The first point is centered on the pressure plate.
		Vector2.ZERO,
		# The second point is to the left or right of the pressure plate,
		# vertically aligned with the door.
		Vector2(door.position.x, 0.0),
		# The last point is centered on the door.
		door.position
	]
	connect("body_entered", self, "_on_Area2D_body_entered")
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Area2D_body_entered(godot: Node) -> void:
	animation_player.play("open")
	door_animation_player.play("open")
	timer.start()


func _on_Timer_timeout() -> void:
	animation_player.play("closed")
	door_animation_player.play("closed")


# This function tells Godot to display a warning sign next to a node when it
# returns a message. If it returns an empty string, however, nothing happens.
func _get_configuration_warning() -> String:
	# We ensure that the pressure plate has a child node named "Door" and that
	# it is a StaticBody2D.
	var door_node := get_node_or_null("Door") as StaticBody2D
	if not door_node:
		return "This node needs a child node named Door, either an instance of DoorHorizontal or DoorVertical."
	return ""
