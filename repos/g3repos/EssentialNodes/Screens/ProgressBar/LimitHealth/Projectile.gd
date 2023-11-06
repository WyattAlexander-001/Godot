class_name Projectile
extends RigidBody2D

const PLAYER_LAYER := 0

export var damage: int = 20
var direction := Vector2.ONE

var _speed: float = 500.0

onready var _anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	set_angular_velocity(2.0)
	set_linear_velocity(direction * _speed)

func destroy() -> void:
	set_collision_layer_bit(PLAYER_LAYER, false)
	set_collision_mask_bit(PLAYER_LAYER, false)
	# This will stop the asteroid in place on a collision.
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	# This animation will queue_free the projectile at the end.
	_anim_player.play("explode")


func _on_body_entered(body: Node) -> void:
	destroy()
