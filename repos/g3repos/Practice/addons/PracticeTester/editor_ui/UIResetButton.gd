tool
extends PanelContainer

signal reset_progress_confirmed

onready var reset_button := $ResetButton as Button

onready var _popup := $Popup as ConfirmationDialog


func _ready() -> void:
	reset_button.connect("pressed", self, "_on_ResetButton_pressed")
	_popup.connect("confirmed", self, "emit_signal", ["reset_progress_confirmed"])
	_popup.set_as_toplevel(true)


func _on_ResetButton_pressed() -> void:
	_popup.popup_centered()
