extends CharacterBody2D

@export var gravity = 1600
@export var jump_power = 600

@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var camera = $"../Camera2D"
var active = true
var jumps_remaining = 2
var was_jumping = false
var jump_pitch = 1.0

func _ready():
	$AnimatedSprite2D.play("run", true)
	pass


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	
	if active:
		camera.position = position
		if was_jumping and is_on_floor():
			was_jumping = false
			jumps_remaining = 2
			sprite.play("run")
			jump_pitch = 1.0 # Reset To Normal Pitch
		if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
			jumps_remaining -= 1
			was_jumping = true
			velocity.y = -jump_power
			if jumps_remaining ==1:
				sprite.play("jump")
			else:
				sprite.play("double jump")	
			jump_sound.set_pitch_scale(jump_pitch)
			jump_sound.play()
			jump_pitch += 0.25

