extends VBoxContainer

var character_stats: Resource = null

onready var label_anchor := $TextureRect/LabelAnchor
onready var punch_button := $PunchButton
onready var take_hit_button := $TakeHitButton
onready var lockpick_button := $LockpickButton

func _ready() -> void:
	punch_button.connect("pressed", self, "_on_PunchButton_pressed")
	take_hit_button.connect("pressed", self, "_on_HitButton_pressed")
	lockpick_button.connect("pressed", self, "_on_LockpickButton_pressed")


func _on_PunchButton_pressed() -> void:
	if not character_stats or not 'strength' in character_stats:
		_pop_label("+0", Color.white)
		return
	var modifier := int(rand_range(character_stats.strength - 2, character_stats.strength + 3))
	var critical: bool = modifier >= character_stats.strength
	var color = Color.lawngreen if critical else Color.aquamarine
	_pop_label("+%s"%[modifier], color)


func _on_HitButton_pressed() -> void:
	if not character_stats or not 'endurance' in character_stats:
		_pop_label("-10", Color.red)
		return
	var modifier := max(0, int(10.0 - rand_range(character_stats.endurance/2, character_stats.endurance*2)))
	var color := Color.red if modifier > 7 else (Color.orangered if modifier > 3 else (Color.white if modifier < 2 else Color.orange))
	_pop_label("-%s"%[modifier], color)


func _on_LockpickButton_pressed() -> void:
	if not character_stats or not 'intelligence' in character_stats:
		_pop_label("failure (0%)", Color.red)
		return
	var modifier := int((rand_range(character_stats.intelligence / 2, character_stats.intelligence) / 7) * 100)
	var success := modifier >= 50
	var color := Color.green if success else Color.red
	var label := "success" if success else "failure"
	_pop_label("%s (%s%%)"%[label, modifier], color)


func _pop_label(text: String, color: Color) -> Label:
	var label := Label.new()
	label_anchor.add_child(label)
	label.text = text
	label.modulate = color
	label.anchor_left = 0.5
	label.anchor_right = 0.5
	label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	var tween := Tween.new()
	label.add_child(tween)
	tween.connect("tween_all_completed", label, "queue_free")
	tween.interpolate_property(label, "rect_position:y", -50, -250, 1)
	tween.interpolate_property(label, "rect_position:x", null, label.rect_position.x + rand_range(-10, 10), 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(label, "modulate:a", null, 0, 1)
	tween.start()
	return label
