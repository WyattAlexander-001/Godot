extends Panel

# We export the variable to drag character stat files into the Inspector and
# test them with the menu.
export var character_stats: Resource = null
export var skill_points := 5 setget set_skill_points

onready var strength_spinbox := $HBoxContainer/Stats/HBoxContainer/StrengthSpinBox
onready var endurance_spinbox := $HBoxContainer/Stats/HBoxContainer2/EnduranceSpinBox
onready var intelligence_spinbox := $HBoxContainer/Stats/HBoxContainer3/IntelligenceSpinBox
onready var skill_points_label := $HBoxContainer/Stats/HBoxContainer4/RemainingPointsLabel
onready var reset_button := $HBoxContainer/Stats/HBoxContainer4/ResetButton
onready var ui_character := $HBoxContainer/UICharacter


func _ready() -> void:
	if not character_stats:
		return

	_update_spinboxes()
	ui_character.character_stats = character_stats

	# The value_changed signal of the spin box emits along with the new value
	# displayed in the interface.
	strength_spinbox.connect("updated", self, "_on_StrengthSpinBox_value_changed")
	endurance_spinbox.connect("updated", self, "_on_EnduranceSpinBox_value_changed")
	intelligence_spinbox.connect("updated", self, "_on_IntelligenceSpinBox_value_changed")
	reset_button.connect("pressed", self, "_on_ResetButton_pressed")
	


func _update_spinboxes() -> void:
	# Replace this with the code listed in the lesson to update the spinboxes'
	# values.
	pass

func _on_ResetButton_pressed() -> void:
	character_stats.strength = 2
	character_stats.endurance = 2
	character_stats.intelligence = 2
	_update_spinboxes()
	set_skill_points(5)
	
	
# Sets skill points, updates the label, and updates the maximum amount of all
# the spinboxes
func set_skill_points(new_skill_points: int) -> void:
	if new_skill_points < 0:
		new_skill_points = 0
	skill_points = new_skill_points
	skill_points_label.text = str(skill_points)


# ANCHOR:callback_functions
# Each of these functions updates the character state matching the spin box.
func _on_StrengthSpinBox_value_changed(new_value: int) -> void:
	character_stats.strength = new_value
	

func _on_EnduranceSpinBox_value_changed(new_value: int) -> void:
	character_stats.endurance = new_value


func _on_IntelligenceSpinBox_value_changed(new_value: int) -> void:
	character_stats.intelligence = new_value

# END:callback_functions
