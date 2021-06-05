
extends Camera

# Member variables
var collision_exception = []
var min_distance = 14.5
var max_distance = 15.0
export var angle_v_adjust = -20.0
export var startPosition = Vector3(-60,3,60)

var max_height = 2
var min_height = 0


#set at ready
var origin
var target_orig

var forward_vec
var reverse
var controlStarted
var camShiftSentinel

func _physics_process(dt):
	
	if (Input.is_action_pressed("Accelerate") || Input.is_action_pressed("Reverse")):
		controlStarted = true
	
#	var engine = get_parent().get_parent().engine_force
	var speed = get_parent().get_parent().get_linear_velocity().length()
	min_distance = speed / 15
	max_distance = speed / 12

	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var delta = pos - target
	
	# Regular delta follow
	
	# Check ranges
	if (delta.length() < min_distance):
		delta = delta.normalized()*min_distance
	elif (delta.length() > max_distance):
		delta = delta.normalized()*max_distance

	# Check upper and lower height
	if ( delta.y > max_height):
		delta.y = max_height
	if ( delta.y < min_height):
		delta.y = min_height
	
	pos = target + delta
	
	if !controlStarted:
		look_at_from_position(startPosition, target, up)
	else:
		if camShiftSentinel <= 30:
			camShiftSentinel = camShiftSentinel + 1.0
			var d = pos.linear_interpolate(startPosition,1.0/camShiftSentinel)
			self.global_translate((pos-d)/4.0)
			look_at(target,up)
		if camShiftSentinel > 30:
			look_at_from_position(pos, target, up)
	
	# Turn a little up or down
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust))*t.basis
	set_transform(t)
	

func _ready():
	#Set origin
	origin = get_global_transform().origin
	target_orig = get_parent().get_global_transform().origin
	controlStarted = false
	camShiftSentinel = 0.0
	
	# Find collision exceptions for ray
	var node = self
	while(node):
		if (node is RigidBody):
			collision_exception.append(node.get_rid())
			break
		else:
			node = node.get_parent()
	set_physics_process(true)
	# This detaches the camera transform from the parent spatial node
	set_as_toplevel(true)
