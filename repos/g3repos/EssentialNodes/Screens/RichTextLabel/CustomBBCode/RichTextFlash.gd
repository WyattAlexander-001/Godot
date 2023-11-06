tool
extends RichTextEffect
class_name RichTextFlash

var bbcode := "flash"


func _process_custom_fx(char_fx: CharFXTransform):
	var target_color: Color = char_fx.env.get("color", Color.firebrick)
	char_fx.color = Color.white.linear_interpolate(target_color, fmod(char_fx.elapsed_time, 1.0))
	return true
