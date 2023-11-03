extends KinematicBody2D

export var health := 100

onready var progress_bar := $ProgressBar


func _ready() -> void:
	progress_bar.value = health
