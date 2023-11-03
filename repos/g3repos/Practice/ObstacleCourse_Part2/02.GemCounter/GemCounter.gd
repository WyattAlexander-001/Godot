extends YSort


var counter := 0

onready var godot_area: Area2D = $Godot/Area2D
onready var ui_counter: Label = $UI/Counter


func _ready() -> void:
	# Connect godot_area's "area_entered" signal to the
	# _on_GodotArea2D_area_entered() function.
	pass


func _on_GodotArea2D_area_entered(_area: Area2D) -> void:
	# 1. Increase the counter variable by one.
	# 2. Set the ui_counter.text property to
	#    "Gems: " plus the counter variable converted to string
	#    using the str() function.
	pass
