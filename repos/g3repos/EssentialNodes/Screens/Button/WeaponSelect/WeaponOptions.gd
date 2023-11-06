extends Control

export var rocket: PackedScene
export var gattling: PackedScene
export var bomb: PackedScene
export var player_path: NodePath

var weapon_list := {}

onready var _player: KinematicBody2D = get_node(player_path)
onready var _buttons := $ButtonContainer.get_children()


func _ready() -> void:
	weapon_list = {"Rocket": rocket, "Gattling": gattling, "Bomb": bomb}
	for button in _buttons:
		button.connect("toggled", self, "button_toggled", [button])
	_buttons[0].pressed = true


func button_toggled(toggle_value: bool, button: Button) -> void:
	if not toggle_value:
		return
	set_weapon(button.text)


func set_weapon(weapon_name: String) -> void:
	var weapon = weapon_list[weapon_name].instance()
	_player.change_weapon(weapon)
