extends Node

const HISTORY_LENGTH := 9
const PLAYER_COLORS := {
	"Arthur": Color.mediumspringgreen,
	"Ford": Color.hotpink,
	"Trillian": Color.royalblue,
	"Marvin": Color.darkorange,
}
const REPLY_TEMPLATE := "[color=#%s]%s[/color]: %s\n"

export var player_name := "Marvin"

onready var _line_edit := $NinePatchRect/VBoxContainer/HBoxContainer/LineEdit
onready var _chat_log := $NinePatchRect/VBoxContainer/ChatLog


func _ready() -> void:
	randomize()


func add_reply(text: String, sender_name: String) -> void:
	var color: Color = PLAYER_COLORS[sender_name]
	_chat_log.bbcode_text += REPLY_TEMPLATE % [color.to_html(false), sender_name, text]

	while _chat_log.bbcode_text.count("\n") > HISTORY_LENGTH:
		var newline_index: int = _chat_log.bbcode_text.find("\n") + 1
		_chat_log.bbcode_text = _chat_log.bbcode_text.right(newline_index)


func send_chat_message() -> void:
	if _line_edit.text.length() == 0:
		return
	var text: String = _line_edit.text.replace("[", "{").replace("]", "}")
	add_reply(text, player_name)
	_line_edit.text = ""


func _on_LineEdit_text_entered(new_text: String) -> void:
	send_chat_message()


func _on_Button_pressed() -> void:
	send_chat_message()
