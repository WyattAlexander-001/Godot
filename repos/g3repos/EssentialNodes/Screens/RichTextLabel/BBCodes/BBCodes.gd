extends Control

var sentences := [
	"I can say words that are [color=red]red[/color].",
	"I can [u]underline words[/u] that I think are important.",
	"[s]Scratch that I didn't want to say any of this.[/s]",
	"[shake rate=5 level=10]I don't feel so good.[/shake]",
	"[img=32x32]res://Screens/Area2D/Enemies/enemy.png[/img]Wow is that me?!",
	"[color=#C2B280]What an interesting shade of ecru.[/color]",
	"[center]where am I?[/center][right]I'm on the right.[/right]",
	"[tornado radius=5 freq=2]Agggghhhh![/tornado]",
]

onready var _rich_text_label := $NinePatchRect/RichTextLabel
onready var _animation_player := $EnemySprite/AnimationPlayer


func _ready() -> void:
	speak()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		speak()


func speak() -> void:
	assert(len(sentences) > 1)
	while _rich_text_label.bbcode_text == sentences.front():
		sentences.shuffle()
	_rich_text_label.bbcode_text = sentences.front()
	_animation_player.stop()
	_animation_player.play("speak")
