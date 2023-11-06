extends RigidBody2D

# We expose this node for other nodes to access.
# This is part of our guidelines at GDQuest: we try to explicitly expose things
# teammates can safely use in their code.
onready var line: Line2D = $Line2D
