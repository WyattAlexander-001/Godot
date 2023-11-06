tool
extends RichTextEffect
class_name RichTextCensor

var censors: Dictionary = {"e": "3"}

var bbcode := "censor"


func _process_custom_fx(char_fx: CharFXTransform):
	for key in censors.keys():
		if ord(key) == char_fx.character:
			char_fx.character = ord(censors[key])
	return true
