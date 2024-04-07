extends Node3D
@onready var rear_red_light = $RearRedLight
@onready var front_red_light = $FrontRedLight
@onready var cross_light_red_front = $CrossLightRedFront
@onready var cross_light_red_rear = $CrossLightRedRear

@onready var rear_yellow_light = $RearYellowLight
@onready var front_yellow_light = $FrontYellowLight

@onready var rear_green_light = $RearGreenLight
@onready var front_green_light = $FrontGreenLight
@onready var cross_light_green_light_front = $CrossLightGreenLightFront
@onready var cross_light_green_light_rear = $CrossLightGreenLightRear

enum States {
	STATE_1, # Green
	STATE_2, # Yellow
	STATE_3  # Red
}

var current_state = States.STATE_1
var state_timer = Timer.new()

func _ready():
	add_child(state_timer)
	state_timer.connect("timeout", Callable(self, "_on_state_timer_timeout"))
	set_state(current_state)

func set_state(state):
	current_state = state
	# Turn all lights off
	rear_red_light.visible = false
	front_red_light.visible = false
	cross_light_red_front.visible = false
	cross_light_red_rear.visible = false
	rear_yellow_light.visible = false
	front_yellow_light.visible = false
	rear_green_light.visible = false
	front_green_light.visible = false
	cross_light_green_light_front.visible = false
	cross_light_green_light_rear.visible = false

	# Then turn specific lights on based on the state
	match current_state:
		States.STATE_1:
			state_timer.start(10) # Green state duration
			front_green_light.visible = true
			rear_green_light.visible = true
			cross_light_green_light_front.visible = true
			cross_light_red_rear.visible = true
		States.STATE_2:
			state_timer.start(5) # Yellow state duration
			front_yellow_light.visible = true
			rear_yellow_light.visible = true
			cross_light_green_light_front.visible = true
			cross_light_red_rear.visible = true
		States.STATE_3:
			state_timer.start(15) # Red state duration
			rear_red_light.visible = true
			front_red_light.visible = true
			cross_light_red_front.visible = true
			cross_light_green_light_rear.visible = true

func _on_state_timer_timeout():
	# Move to the next state
	current_state = (current_state + 1) % 3
	set_state(current_state)



func _process(delta):
	pass

	
