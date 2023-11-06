extends StaticBody2D

onready var _anim_player := $PlayerSideSkin/AnimationPlayer
onready var _blood_particle := $BloodParticles2D

func get_hurt(motion: Physics2DTestMotionResult) -> void:
	_blood_particle.rotation = motion.collision_normal.angle()
	_blood_particle.global_position = motion.collision_point
	_blood_particle.emitting = true
	_anim_player.play("hurt")
