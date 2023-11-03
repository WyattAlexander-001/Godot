extends Node2D

onready var animation_player := $AnimationPlayer

var start_scale := scale

func _ready() -> void:
	if Engine.editor_hint or not owner:
		set_physics_process(false)
		return

	yield(owner, "ready")
	if not owner.get("velocity") is Vector2:
		set_physics_process(false)
		printerr("Skin expected a owner node with a velocity property but the owner node doesn't have those. Turning off skin.")


func play(animation: String) -> void:
	animation_player.play(animation)


func _physics_process(_delta: float) -> void:
	var horizontal_direction = 0.0

	var input_direction := sign(Input.get_axis("move_left", "move_right"))
	if is_zero_approx(input_direction):
		horizontal_direction = sign(owner.velocity.x)
	else:
		horizontal_direction = input_direction
	
	var is_jumping = owner.velocity.y < 0 and not owner.is_on_floor()
	if not is_zero_approx(horizontal_direction):
		scale.x = sign(horizontal_direction) * start_scale.x

	if is_jumping:
		play("jump")
	elif owner.velocity.y > 0.0:
		play("fall")
	elif owner.is_on_wall():
		play("push")
	elif owner.is_on_floor():
		if not is_zero_approx(horizontal_direction):
			play("run")
		else:
			play("idle")
