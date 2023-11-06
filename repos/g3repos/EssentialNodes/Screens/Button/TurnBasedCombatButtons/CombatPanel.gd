extends Control

export var player_animator_path: NodePath

onready var _player_animator: AnimationPlayer = get_node(player_animator_path)
onready var _container := $NinePatchRect/GridContainer


func _ready() -> void:
	for attack in _player_animator.get_animation_list():
		var button := Button.new()
		button.text = attack
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.size_flags_vertical = SIZE_EXPAND_FILL
		_container.add_child(button)
		button.connect("pressed", _player_animator, "play", [attack])
