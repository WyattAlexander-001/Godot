extends RigidBody

export var blast_impulse = 5.0

onready var _model: Spatial = $Grenade
onready var _explosion: Particles = $Explosion
onready var _explosion_area: Area = $ExplosionRadius
onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	set_as_toplevel(true)
	_animation_player.play("Detonate")

func _explode() -> void:
	_model.hide()
	_explosion.set_as_toplevel(true)
	_explosion.emitting = true

	var colliders = _explosion_area.get_overlapping_bodies()
	for body in colliders:
		if body is RigidBody:
			var direction := global_transform.origin.direction_to(body.global_transform.origin)
			body.apply_central_impulse(blast_impulse * direction)
