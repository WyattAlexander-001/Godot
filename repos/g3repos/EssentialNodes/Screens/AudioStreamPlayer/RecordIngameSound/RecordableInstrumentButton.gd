extends Button

export var sample: AudioStreamSample
export var pitch := 1.0

onready var _audio_record: AudioStreamPlayer = $AudioStreamPlayer
onready var _audio_player: AudioStreamPlayer = $AudioStreamPlayer2


func _ready() -> void:
	for audio_stream_player in get_children():
		audio_stream_player.stream = sample
		audio_stream_player.pitch_scale = pitch
		connect("button_up", audio_stream_player, "stop")
		connect("button_down", audio_stream_player, "play")
