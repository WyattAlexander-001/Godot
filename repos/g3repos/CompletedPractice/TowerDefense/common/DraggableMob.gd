extends KinematicBody2D
onready var progress_bar := $ProgressBar

export var health := 100

func _ready() -> void:
	progress_bar.value = health
