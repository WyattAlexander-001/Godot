extends RigidBody2D

const BLAST_IMPULSE := 1500.0

var rocket_direction := Vector2.ZERO

onready var _explosion_area: Area2D = $ExplosionRadius
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	# We use the body_entered signal to detect when the rocket collides with something.
	connect("body_entered", self, "_on_body_entered")
	set_as_toplevel(true)
	linear_velocity = 1500 * rocket_direction
	_animation_player.play("fire")
	_animation_player.queue("explode")
	rotation = rocket_direction.angle()


func explode() -> void:
	_animation_player.play("explode")
	var colliders := _explosion_area.get_overlapping_bodies()
	for body in colliders:
		if body.has_method("take_damage"):
			body.take_damage()
		if body is RigidBody2D:
			var direction := global_position.direction_to(body.global_position)
			body.apply_central_impulse(BLAST_IMPULSE * direction)


func _on_body_entered(_body: Node) -> void:
	explode()
