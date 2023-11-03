tool
extends CenterContainer

export(Resource) var book setget set_book

onready var animation_player := $AnimationPlayer
onready var button := $VBoxContainer/CenterContainer/Button
onready var label := $VBoxContainer/PanelContainer/MarginContainer/Label


func _ready() -> void:
	button.connect("pressed", self, "_on_Button_pressed")
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_finished")


func _on_Button_pressed() -> void:
	animation_player.play("text")
	button.disabled = true
	# Set the label's text using your new function from the Book resource here.
	pass


func _on_AnimationPlayer_finished(_anim_name: String) -> void:
	button.disabled = false


func set_book(new_book: Resource) -> void:
	assert(new_book == null or new_book is Book, "`book` must be a Book resource")
	book = new_book
