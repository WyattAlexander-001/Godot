extends PracticeTests

const CreditLine := preload("CreditLine.gd")

const expected_additional_credits := [
	{"role": "Level Design", "name": "Bonnie Petersen"},
	{"role": "Composer", "name": "Judy Prince"},
]


func _init() -> void:
	add_requirement(".", ["credits"], ["add_credit"])


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1.0), "timeout")


func test_credits_array_has_four_persons() -> String:
	var count: int = scene_root.credits.size()
	if count != 4:
		return tr("We expected to find 4 persons in the credits array but got %s instead." % count)
	return ""


func test_credits_dictionary_has_the_correct_last_two_persons() -> String:
	if scene_root.credits.size() != 4:
		return tr(
			"There are not four persons in the credits dictionary so we can't test if the last two match the expected ones."
		)

	for index in 2:
		var user_entry: Dictionary = scene_root.credits[index + 2]

		if not user_entry:
			return tr(
				"It seems that one of the values in the credits array is not a dictionary. We can't test it as a result."
			)

		var expected: Dictionary = expected_additional_credits[index]
		if user_entry.name != expected.name or user_entry.role != expected.role:
			return tr(
				(
					"We expected to find person '%s' with role '%s' but instead got '%s' with role '%s'"
					% [expected.name, expected.role, user_entry.name, user_entry.role]
				)
			)
	return ""
