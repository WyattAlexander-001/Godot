extends Control
export var laser: PackedScene
export var autocannon: PackedScene
export var _player_path: NodePath

var _weapon_list: Dictionary

onready var _player: KinematicBody2D = get_node(_player_path)
onready var _weapon_button: OptionButton = $MainRect/MarginContainer/VBoxContainer/WeaponOptionButton


func _ready() -> void:
	_weapon_list = {"Laser": laser, "Autocannon": autocannon}
	for weapon in _weapon_list:
		_weapon_button.add_item(weapon)
		# Whenever an item is added, by default it goes to the end of the OptionButton. as a result
		# We can get its index by looking up the number of options with get_item_count().
		_weapon_button.set_item_metadata(_weapon_button.get_item_count() - 1, _weapon_list[weapon])
	_weapon_button.connect("item_selected", self, "weapon_selected")
	# We run the weapon selected function here, to automatically equip the default option when the
	# Game starts.
	weapon_selected(_weapon_button.get_selected_id())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		visible = not visible

func weapon_selected(_weapon_id: int) -> void:
	var new_weapon = _weapon_button.get_selected_metadata().instance()
	_player.change_weapon(new_weapon)
	visible = false

