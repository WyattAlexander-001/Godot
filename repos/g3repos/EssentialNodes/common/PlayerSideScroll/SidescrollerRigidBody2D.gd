extends RigidBody2D

export var speed := 6000.0
export var jump := 100000.0

onready var _skin := $PlayerSideSkin
onready var _anim_player := $PlayerSideSkin/AnimationPlayer
onready var _start_scale: Vector2 = _skin.scale


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if is_on_floor(state) and Input.is_action_pressed("jump"):
		apply_central_impulse(Vector2.UP * jump * state.step)

	apply_central_impulse(Vector2.RIGHT * direction * speed * state.step)
	if not is_zero_approx(direction):
		_skin.scale.x = sign(direction) * abs(_skin.scale.x)

	if is_on_floor(state):
		if is_zero_approx(direction):
			_anim_player.play("idle")
		else:
			_anim_player.play("run")
	else:
		if linear_velocity.y < 0.0:
			_anim_player.play("jump")
		else:
			_anim_player.play("fall")


func is_on_floor(state: Physics2DDirectBodyState) -> bool:
	# Contacts_reported needs to be high enough to count all surfaces on body
	for contact in state.get_contact_count():
		var contact_normal := state.get_contact_local_normal(contact)
		# If the contact is below us we are on the floor
		if contact_normal.dot(Vector2.UP) > 0.5:
			return true
	return false
