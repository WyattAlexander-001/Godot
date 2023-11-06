extends Node2D

onready var _area := $Area2D


func _ready() -> void:
	set_as_toplevel(true)


func explode() -> void:
    # Get all bodies in the explosions radius
	var bodies: Array = _area.get_overlapping_bodies()

	for body in bodies:
		if body.has_method("take_damage"):
            # You can add this take_damage function to whatever scenes you want
            # the explosion to damage.
			body.take_damage()
