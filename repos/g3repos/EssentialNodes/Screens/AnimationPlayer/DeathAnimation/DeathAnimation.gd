extends Node2D

onready var _player := $Player
onready var _blast_particles := $Player/BlastParticles
onready var _explosion_particles := $Player/ExplosionParticles
onready var _animation_player := $AnimationPlayer


func _on_SelfDestructButton_pressed() -> void:
    # If the animation is already playing, the screen is already fading out, so
    # we avoid running the function a second time.
	if _animation_player.is_playing():
		return

	# We spawn some particles and pause the player.
	_blast_particles.restart()
	_explosion_particles.restart()
	_player.set_physics_process(false)

	_animation_player.play("fade_out")
    # Here, we wait for the animation to end.
	yield(_animation_player, "animation_finished")

	_player.set_physics_process(true)
    # This animation reloads and restarts the current scene, which works for a
    # simple respawn.
	_animation_player.play("fade_in")
