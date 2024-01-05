@tool #reload saved scene
extends Control

func _draw() -> void:
	# Center Dot
	draw_circle(Vector2.ZERO,4,Color.DIM_GRAY) #Shadow
	draw_circle(Vector2.ZERO,3,Color.WHITE)
	
	# Lines
	draw_line(Vector2(16,0), Vector2(24,0), Color.WHITE, 2) # Right
	draw_line(Vector2(-16,0), Vector2(-24,0), Color.WHITE, 2) # Left
	draw_line(Vector2(0,16), Vector2(0,24), Color.WHITE, 2) # Bot
	draw_line(Vector2(0,-16), Vector2(0,-24), Color.WHITE, 2) # Top
