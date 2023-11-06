extends Node

onready var _audio_player := $AudioStreamPlayer
onready var _button := $CheckButton


func _ready() -> void:
	_button.connect("toggled", self, "toggle_playback")


func toggle_playback(do_play: bool) -> void:
	# We can check if the soundtrack is playing with the `playing` property.
	# We need that for the stream_pause property to have an effect.
	if not _audio_player.playing:
		_audio_player.play()
	# This property pauses the stream. It only has an effect if the audio is playing.
	_audio_player.stream_paused = not do_play
