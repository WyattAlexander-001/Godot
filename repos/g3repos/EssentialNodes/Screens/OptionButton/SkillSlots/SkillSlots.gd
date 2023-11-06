extends Control

const POINTS_TEMPLATE := "Perk points: %d"

export var available_points := 6 setget set_available_points

onready var _perk_points: Label = $MainRect/VBoxContainer/PerkPoints
onready var _label_animator: AnimationPlayer = $MainRect/VBoxContainer/PerkPoints/AnimationPlayer
onready var _engines: HBoxContainer = $MainRect/VBoxContainer/Engines/Abilities
onready var _engines_button: Button = $MainRect/VBoxContainer/Engines/Button
onready var _shields: HBoxContainer = $MainRect/VBoxContainer/Shields/Abilities
onready var _shields_button: Button = $MainRect/VBoxContainer/Shields/Button


func _ready() -> void:
	_engines_button.connect("pressed", self, "level_up", [_engines])
	_shields_button.connect("pressed", self, "level_up", [_shields])


func level_up(ability_container: Container) -> void:
	if available_points == 0:
		return

	for child in ability_container.get_children():
		if not child.is_available():
			continue

		child.purchase()
		self.available_points -= 1
		break


func set_available_points(points_in: int) -> void:
	available_points = points_in
	if not _label_animator:
		yield(owner, "ready")
	_perk_points.text = POINTS_TEMPLATE % available_points
	_label_animator.play("update")
