class_name CharacterStats
extends Resource

# Changing the strength variable from the menu will trigger a call to the
# set_strength() function.
export var strength := 2 setget set_strength
export var endurance := 2 setget set_endurance
export var intelligence := 2 setget set_intelligence


# A setter function will always be called with the new value we're trying to
# assign to the variable.
func set_strength(new_strength: int) -> void:
	# We must always update the variable manually.
	strength = new_strength
	# We can then call any code that we want, like our save() function.
	save()


func set_endurance(new_endurance: int) -> void:
	endurance = new_endurance
	save()


func set_intelligence(new_intelligence: int) -> void:
	intelligence = new_intelligence
	save()


func save() -> void:
	ResourceSaver.save(resource_path, self)
