extends Button

export var pitch := 1.0
export var sample: AudioStreamSample

onready var _audio_player := $AudioStreamPlayer


func _ready() -> void:
	_audio_player.pitch_scale = pitch
	_audio_player.stream = sample
	connect("button_down", _audio_player, "play")
	connect("button_up", _audio_player, "stop")
