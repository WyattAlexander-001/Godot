extends Node2D

onready var progress_bar := $ProgressBar
onready var mob_spawner := $MobSpawner


func _ready() -> void:
	# the signal `mob_reached_end` is emitted every time a mob reaches the last
	# point on its path
	mob_spawner.connect("mob_reached_end", self, "_on_mob_reached_end")


# Called every time a mob reaches its last point.
func _on_mob_reached_end() -> void:
	# We reduce the progress bar value by ten.
	# note that we don't have an actual game over screen or anything,
	# so once the progress bar reaches 0, we do nothing
	if progress_bar.value > 0:
		progress_bar.value -= 10
