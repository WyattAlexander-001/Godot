extends VBoxContainer

onready var role_label := $RoleLabel
onready var name_label := $NameLabel


func _prepare_async():
	._prepare_async()
	yield(get_tree().create_timer(1.0), "timeout")


func set_role(new_role: String) -> void:
	role_label.text = new_role


func set_name(new_name: String) -> void:
	name_label.text = new_name
