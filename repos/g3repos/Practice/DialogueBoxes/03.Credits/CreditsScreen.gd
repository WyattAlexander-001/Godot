
extends PanelContainer

const CreditLineScene := preload("CreditLine.tscn")

onready var credits_container := $MarginContainer/ScrollContainer/VBoxContainer

var credits := [
	{"role": "Engine", "name": "Johnny Cormack"},
	{"role": "Programming", "name": "Jane Romero"},
	# Add Bonnie Petersen with the Level Design role and Judy Prince with the Composer role.
	# Be sure to capitalize the names and roles!
]


func _ready() -> void:
	for credit in credits:
		add_credit(credit.role, credit.name)


func add_credit(role: String, name: String) -> void:
	var credit_line := CreditLineScene.instance()
	credits_container.add_child(credit_line)
	credit_line.set_name(name)
	credit_line.set_role(role)
