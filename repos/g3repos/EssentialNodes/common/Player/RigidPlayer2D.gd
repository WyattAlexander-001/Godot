class_name RigidPlayer2D
extends RigidBody2D

export var move_force_amplitude := 6000.0

onready var _sprite := $Sprite
onready var _animation_player := $AnimationPlayer
onready var _weapon := get_node_or_null("Weapon")  # player doesn't always have a weapon

onready var _flame_main := $Sprite/FlameMain
onready var _flame_left := $Sprite/FlameLeft
onready var _flame_right := $Sprite/FlameRight


func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	applied_force = direction * move_force_amplitude

	_sprite.rotation = linear_velocity.angle() + PI / 2
	if _weapon:
		_weapon.rotation = _sprite.rotation

	# Updating flames
	var speed_rate := linear_velocity.length() / 1000.0

	_flame_main.scale = Vector2.ONE * speed_rate
	_flame_left.scale = Vector2.ONE * speed_rate * 0.35
	_flame_right.scale = Vector2.ONE * speed_rate * 0.35


func take_damage() -> void:
	start_blink(false)


func start_blink(loop := false) -> void:
	_animation_player.get_animation("blink").set_loop(loop)
	_animation_player.play("blink")


func stop_blink():
	_animation_player.stop()
	_animation_player.seek(0, true)
