extends AudioStreamPlayer

# Using the export hint in parentheses, we tell Godot to create an array that
# only accepts audio streams.
export (Array, AudioStream) var effects_list


## Overrides the play() method to play a random sound from an array.
func play(from_position: float = 0.0) -> void:
	# We calculate a random index and select the corresponding sound from the
	# `effects_list` array.
	var index: int = randi() % effects_list.size()
	stream = effects_list[index]
	# As we override the method, we use the dot notation to call play() in the
	# parent class.
	.play(from_position)
