extends Node

# We first get the bus with the recording effect and grab a reference to the
# effect from it.
var _record_bus := AudioServer.get_bus_index("Record")
var _effect: AudioEffectRecord = AudioServer.get_bus_effect(_record_bus, 0)
var _recording: AudioStreamSample

# This is a reference to the AudioStreamPlayer we use to listen to our
# recording.
onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var _record_button: TextureButton = $RecordButton
onready var _play_button: Button = $PlayButton


func _ready() -> void:
	_record_button.connect("toggled", self, "toggle_recording")
	_play_button.connect("pressed", self, "play_recording")


func toggle_recording(do_record: bool) -> void:
	# Before toggling the recording off, we store the recorded stream to play it
	# back later.
	if _effect.is_recording_active():
		_recording = _effect.get_recording()
	# We use the following method to turn recording on and off.
	_effect.set_recording_active(do_record)




func play_recording() -> void:
	# To listen to the recorded track, we assign the recording to our
	# AudioStreamPlayer and play like usual.
	_audio_player.stream = _recording
	_audio_player.play()
