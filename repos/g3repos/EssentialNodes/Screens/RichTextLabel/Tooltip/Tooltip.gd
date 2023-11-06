extends Control

var glossary := {
	"space": "Space is big. You just won't believe how vastly, hugely, mind-bogglingly big it is.",
	"ships": "Is there any tea on this spaceship?",
	"Earth":
	"Fifteen years was a long time to be stranded anywhere, particularly somewhere as mind-boggingly dull as Earth.",
	"swallowed by a small dog": "In an infinite Universe anything can happen."
}

onready var _rich_text_label := $NinePatchRect/RichTextLabel
onready var _tooltip_display := $CanvasLayer/TooltipDisplay


func _ready() -> void:
	highlight_keywords(_rich_text_label)


func highlight_keywords(label: RichTextLabel) -> void:
	for keyword in glossary.keys():
		label.bbcode_text = label.bbcode_text.replace(
			keyword, "[color=#ff6666][url]%s[/url][/color]" % keyword
		)


func _on_RichTextLabel_meta_hover_started(meta) -> void:
	_tooltip_display.set_text(meta, glossary[meta])
	_tooltip_display.is_active = true


func _on_RichTextLabel_meta_hover_ended(meta) -> void:
	_tooltip_display.is_active = false
