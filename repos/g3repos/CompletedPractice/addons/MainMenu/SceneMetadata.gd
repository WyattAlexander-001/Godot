extends Reference

var name: String
var path: String
var description: String
var icon: String


func _init(p_name: String, p_path: String, p_description := "", p_icon := "") -> void:
	name = p_name
	path = p_path
	description = p_description
	icon = p_icon
