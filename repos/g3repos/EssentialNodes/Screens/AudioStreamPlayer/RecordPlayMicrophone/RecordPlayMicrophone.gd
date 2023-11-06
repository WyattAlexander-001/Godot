extends Node

var _record_bus := AudioServer.get_bus_index("Record")
var _effect: AudioEffectRecord = AudioServer.get_bus_effect(_record_bus, 0)
var _recording: AudioStreamSample

onready var _recorder: AudioStreamPlayer = $Recorder
onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer

onready var _record_button: TextureButton = $RecordButton
onready var _play_button: Button = $PlayButton


func _ready() -> void:
	_record_button.connect("toggled", self, "toggle_recording")
	_play_button.connect("pressed", self, "play_recording")


func toggle_recording(button_pressed: bool) -> void:
	if _effect.is_recording_active():
		_recording = _effect.get_recording()
	_effect.set_recording_active(button_pressed)


func play_recording() -> void:
	_audio_player.stream = _recording
	_audio_player.play()
