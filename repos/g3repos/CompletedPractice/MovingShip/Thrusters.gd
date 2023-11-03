extends Position2D

onready var flame_main := $FlameMain
onready var flame_left := $FlameLeft
onready var flame_right := $FlameRight


func _ready() -> void:
	if Engine.editor_hint or not owner:
		set_process(false)
		return

	yield(owner, "ready")
	var max_speed = owner.get("max_speed")
	var is_max_speed_valid := max_speed is float or max_speed is int
	var is_velocity_valid := owner.get("velocity") is Vector2
	if not is_velocity_valid or not is_max_speed_valid:
		set_process(false)
		printerr("Thrusters expected a owner node with a velocity and max_speed property but the owner node doesn't have those. Turning off thrusters.")


func _process(_delta: float) -> void:
	# Updating flames
	var speed_rate := min(owner.velocity.length() / owner.max_speed, 1.0)

	flame_main.scale = Vector2.ONE * speed_rate
	flame_left.scale = Vector2.ONE * speed_rate * 0.35
	flame_right.scale = Vector2.ONE * speed_rate * 0.35
