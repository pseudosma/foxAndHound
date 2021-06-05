extends MeshInstance

const landScale = 417.517944
const noise = [13,12,70,9,23,13,14,11,23,21,8,14,17,41,19,13,31,6,10,24]
const additiveNoise = [-44,30,27,-26,49,27,-29]
const subtractiveNoise = [31,-27,28,32,26,46,25,52,-39,24,-33]
const rotationalNoise = [0.3,0.5,0.9,0.8,1.3,1.9,-1.5,-1.1,-0.9,-0.7,-0.4]
const scaleNoise = [1,1.1,1.3,1,1.8,2,1,2.7,1,3]

func randomize_rocks():
	
	var minV = self.to_global(Vector3(-1,0,-1))
	var maxV = self.to_global(Vector3(1,0,1))

	var r1 = get_node("rock1")
	randomize_location_in_range(minV, maxV, r1)
	randomize_rotation(r1)
	randomize_scale(r1)

	var r2 = get_node("rock2")
	randomize_location_in_range(minV, maxV, r2)
	randomize_rotation(r2)
	randomize_scale(r2)

	var r3 = get_node("rock3")
	randomize_location_in_range(minV, maxV, r3)
	randomize_rotation(r3)
	randomize_scale(r3)

	var r4 = get_node("rock4")
	randomize_location_in_range(minV, maxV, r4)
	randomize_rotation(r4)
	randomize_scale(r4)

	var r5 = get_node("rock5")
	randomize_location_in_range(minV, maxV, r5)
	randomize_rotation(r5)
	randomize_scale(r5)


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func randomize_location_in_range(minimum, maximum, spatial):
	var trans = Vector3()
	var n = 1
	var aN = 1
	var sN = 1
	
	var step = abs(maximum.z / landScale)
	var additiveStep = abs(maximum.x / landScale)
	var subtractiveStep = step
	if (step > 20):
		step = fmod(step, 20)
	if (additiveStep > 7):
		additiveStep = fmod(step, 7)
	if (subtractiveStep > 11):
		subtractiveStep = fmod(step, 11)
	n = noise[step - 1]
	aN = additiveNoise[additiveStep - 1]
	sN = subtractiveNoise[subtractiveStep - 1]
	
	trans.x = (fmod(spatial.global_transform.origin.x, n)) + aN - sN
	trans.z = (fmod(spatial.global_transform.origin.z, n)) + aN - sN

	var testVec = spatial.global_transform.origin + trans
	#avoid going over edge
	if (testVec.x > maximum.x):
		trans.x = -n
	if (testVec.z > maximum.z):
		trans.z = -n
	if (testVec.x < minimum.x):
		trans.x = n
	if (testVec.z < minimum.z):
		trans.z = n
	testVec = spatial.global_transform.origin + trans
#	#avoid road
	if (abs(testVec.z) < (landScale / 6)):
		if (trans.z > 0):
			trans.z = n + aN + sN	
		else:
			trans.z = n - aN - sN	
	testVec = spatial.global_transform.origin + trans

	spatial.global_transform.origin = Vector3(testVec.x, spatial.global_transform.origin.y,testVec.z)
	

func randomize_rotation(spatial):
	var step = abs(spatial.global_transform.origin.x * spatial.global_transform.origin.z)
	if (step > 11):
		step = fmod(step, 11)
	
	spatial.rotate_y(rotationalNoise[step - 1])

func randomize_scale(spatial):
	var step = abs(spatial.global_transform.origin.x * spatial.global_transform.origin.z)
	if (step > 10):
		step = fmod(step, 10)
	
	spatial.scale_object_local(Vector3(scaleNoise[step - 1],scaleNoise[step - 1],scaleNoise[step - 1]))
	