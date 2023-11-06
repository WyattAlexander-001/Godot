extends Button # Updates button text to match toggle state. Workaround for adding CheckBox/Button styling to the theme.

func _ready():
	connect("toggled", self, "_on_toggled")

func _on_toggled(button_pressed):
	text = "On" if button_pressed else "Off"
