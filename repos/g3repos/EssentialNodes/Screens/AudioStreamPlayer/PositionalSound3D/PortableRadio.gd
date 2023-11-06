extends Interactible3D

onready var _audio_player: AudioStreamPlayer3D = find_node("AudioStreamPlayer3D")
onready var _particles: Particles = find_node("Particles")

func play(is_playing: bool) -> void:
	if _audio_player.playing and is_playing:
		return
	_audio_player.play() if is_playing else _audio_player.stop()
	_particles.emitting = is_playing
