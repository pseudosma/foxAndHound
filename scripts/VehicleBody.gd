extends "vehicle.gd"

# class member variables go here, for example:
var World_node

var last_pos
var distance = 0
var distance_int = 0

func _ready():
	pass

func _physics_process(delta):
	
	#input
	var gas = false
	var braking = false
	var left = false
	var right = false
	
	if (Input.is_action_pressed("Accelerate")):
		gas = true
	
	if (Input.is_action_pressed("Reverse")):
		braking = true
	
	# turning
	if (Input.is_action_pressed("Left")):
		left = true
		
		
	if (Input.is_action_pressed("Right")):
		right = true
	
		
	process_car_physics(delta, gas, braking, left, right)
	