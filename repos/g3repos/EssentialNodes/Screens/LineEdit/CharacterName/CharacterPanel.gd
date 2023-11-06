extends NinePatchRect

var color_list := [
	Color.white, Color.orangered, Color.royalblue, Color.springgreen, Color.gold, Color.orchid
]

onready var _appearance_buttons: Array = $VBoxContainer/HBoxContainer.get_children()
onready var _health_bar: TextureProgress = $AnimatedSprite/Progress
onready var _color_slider: Slider = $VBoxContainer/ColorSlider
onready var _name_label: Label = $AnimatedSprite/NameLabel
onready var _line_edit: LineEdit = $VBoxContainer/LineEdit
onready var _sprite: AnimatedSprite = $AnimatedSprite

var character_name_regex := RegEx.new()

func _ready() -> void:
	# This regular expression helps us filter out unwanted characters. The "^"
	# inside backets mean "find all characters that are not letters or a space".
	character_name_regex.compile("[^A-Za-z ]")

	_line_edit.connect("text_changed", self, "update_player_name")
	_color_slider.connect("value_changed", self, "_on_ColorSlider_value_changed")
	for button in _appearance_buttons:
		button.connect("button_down", self, "toggle_appearance", [button])
	_color_slider.max_value = len(color_list) - 1


func toggle_appearance(button: Button) -> void:
	_sprite.frame = 1 if button.name == "Style1" else 0


func _on_AppearanceSlider_value_changed(value: float) -> void:
	_sprite.frame = int(value)


func _on_ColorSlider_value_changed(value: float) -> void:
	_health_bar.tint_progress = color_list[int(value)]


## Updates the character's name, preventing the player from entering unsupported
## characters.
func update_player_name(new_name: String) -> void:
	var caret_position = _line_edit.caret_position
	# We remove every unwanted character from the string.
	var result = character_name_regex.sub(new_name, "", true)
	_line_edit.text = result
	_name_label.text = result

	# As the function modifies the text, it may also modify the string's length,
	# causing the caret to move. So we update the caret position manually
	#
	# We need to manipulate another variable to do this. It seems the caret's
	# position updates asynchronously after changing the text.
	caret_position -= new_name.length() - result.length()
	_line_edit.caret_position = caret_position
