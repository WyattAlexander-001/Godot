extends Node2D

# `mob_reached_end` will be emitted when a mob reaches the last point
signal mob_reached_end

# Reference to the scene that should be spawned
export(PackedScene) var MobScene := preload("Mob.tscn")

# Reference to the possible paths through the level
# this stores the *paths* to the path nodes. We will need
# to use `get_node` to acquire the actual node referenced
export(Array, NodePath) var paths := []

# mobs limit. Once this number reaches 0, no mob will spawn
export var mobs_amount := 10

# Every time the timer ticks, a mob spawns
onready var timer := $Timer

# Holds all the possible paths in a level, extraced from the paths
var mobs_paths := []


func _ready() -> void:
	if Engine.editor_hint:
		# If we're running in the editor (through `tool`), do not run `_ready()` 
		# at all, skip everything
		return
	
	# we loop over all the path node references, and extract the path points
	for path_node_path in paths:
		var path_node: Path2D = get_node(path_node_path)
		if not (path_node is Path2D):
			push_error("path `%s` is not a Path2D"%[path_node_path])
			continue
		var curve := path_node.curve
		# we will store the points in this array
		var points := PoolVector2Array()
		# we loop over all the path's points, and store each in the `points` array
		for idx in curve.get_point_count():
			# we make the point global before storing it
			var point_position := path_node.to_global(curve.get_point_position(idx))
			points.append(point_position)
		# finally, we append the set of points to the list of possible paths
		mobs_paths.append(points)
	
	if not mobs_paths:
		# We show an error if mobs_path is empty
		push_error("No paths were set. You need to specify at least one Path2D")
		return
	
	# spawn a mob every time the timer runs out
	timer.connect("timeout", self, "spawn_mob")
	
	# don't wait for the timer, spawn the first mob immediately
	spawn_mob()


# Creates a new mob and makes them follow a random path
func spawn_mob() -> void:
	if mobs_amount == 0:
		# don't do anything if the counter is 0
		return
	# instance one mob
	var mob := MobScene.instance()
	# set one of the `mob_paths` paths as the mob's waypoints. We pick it randomly
	mob.points = mobs_paths[randi() % mobs_paths.size()]
	# set a random speed increase for the mob, for variety
	mob.speed += rand_range(0, 30)
	# make sure we know when the mob has reached the last point
	mob.connect("reached_end", self, "_on_mob_reached_end")
	# we add the mob to the stage
	add_child(mob)
	# we decrease the mob counter by one
	mobs_amount -= 1


# called when a mob reaches the last point on their path
func _on_mob_reached_end() -> void:
	emit_signal("mob_reached_end")

