extends Spatial

#var horizontalOffset
const maxDist = 5
var counter = 0
var origin
var vecA = Vector3()
var vecB = Vector3()
var engine
var speed
var x

func _process(delta):
	
	
	var engine = get_parent().engine_force
	vecA = get_parent().get_linear_velocity()
	x = vecA.normalized().dot(vecB.normalized())
#	print(x)
	# < 1 represents turning, stopped,or reversing
#	if (x < 1.0000):
#		if (counter < maxDist):
#			self.translate(Vector3(0,0,-1))
#			++counter
#	else:
#		if (counter >= maxDist):
#			self.translate(Vector3(0,0,1))
#			--counter
#	speed = vecA.length()

#	if (engine < 0):
#		if  (self.translation.z < maxDist):
#			translate_object_local(Vector3(1, 0, 1))
#	else:
#		if (self.translation.z != origin.z):
#			self.transform.origin = origin
#	if (Input.is_action_pressed("Left") && !Input.is_action_pressed("Right")):
#		translate(Vector3(0.2, 0, 0))
#		horizontalOffset += 0.2
#	elif (Input.is_action_pressed("Right") && !Input.is_action_pressed("Left")):
#		translate(Vector3(-0.2, 0, 0))
#		horizontalOffset -= 0.2
#	else:
#		if(horizontalOffset >= 0.1):
#			translate(Vector3(-0.1, 0, 0))
#			horizontalOffset -= 0.1
#		elif (horizontalOffset <= -0.1):
#			translate(Vector3(0.1, 0, 0))
#			horizontalOffset += 0.1
#		else:
#			horizontalOffset == 0
	vecB = vecA

	
func _ready():
	origin = self.translation
#	horizontalOffset = 0