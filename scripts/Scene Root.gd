extends Spatial

const landScale = 417.517944
enum direction {up, down, left, right}
var current_grid = {"up": 0, "down": 0, "left": 0, "right": 0}
var old_grid = {"up": 0, "down": 0, "left": 0, "right": 0}
var current_tiles = []

var car_location = Vector2()
var car_grid_coordinates = Vector2()

var car

func _ready():
	Engine.set_target_fps(30)
	
	var i = 0
	var realR = get_node("road")
	realR.translate(Vector3(0,-5000,0))
	var realG1 = get_node("ground1")
	realG1.global_transform.origin = realR.global_transform.origin
	var realG2 = get_node("ground2")
	realG2.global_transform.origin = realR.global_transform.origin
	var carScn = load("res://assets/car/car.scn")
	car = carScn.instance()
	car.translate(Vector3(20,-6,35))
	car.rotate_y(1.57)
	add_child(car)
	
#	var enemyScn = load("res://assets/enemy/flamingEnemy.scn")
#	var enemy = enemyScn.instance()
#	enemy.translate(Vector3(200,-6,350))
#	#enemy.scale_object_local(Vector3(2.5,2.5,2.5))
#	add_child(enemy)
	
	current_grid.right = 6
	current_grid.left = -6
	insert_row(0)
	while (i < 3):
		i += 1
		insert_row(i * 2)
		insert_row(-i * 2)
	current_grid.up = 6
	current_grid.down = -6
	
	old_grid = current_grid.duplicate()
	set_process(true)

func add_road(x, y):
	var r = get_node("road").duplicate(4)
	r.name = str(y) + "," + str(x)
	r.translate(Vector3(x,5000,y))
	add_child(r)
	r.randomize_rocks()
	r.add_to_group("land")
	current_tiles.append(r.name)
	
func add_ground(x, y, groundInstance):
	var g = get_node(groundInstance).duplicate(4)
	g.name = str(y) + "," + str(x)
	g.translate(Vector3(x,5000,y))
	add_child(g)
	g.randomize_rocks()
	g.add_to_group("land")
	current_tiles.append(g.name)

func remove_land(name):
	var n = get_node(name)
	if (n != null):
		n.remove_from_group("land")
		n.queue_free()

func insert_row(increment):
	var c = current_grid.left
	while (c <= current_grid.right):
		if (c % 2 == 0):
			if (c != 0):
				if (c % 4 == 0):
					add_ground(increment, c,"ground1")
				else:
					add_ground(increment, c,"ground2")
			elif(c == 0):
				add_road(increment,c)
		c+=1

func calculate_new_tiles():
	var arr = []
	var h = current_grid.down
	while (h <= current_grid.up):
		var w = current_grid.left
		while (w <= current_grid.right):
			arr.append(str(w) + "," + str(h))
			w += 2
		h+=2
	return arr

func update_grid(grid):
	var x = int(car_grid_coordinates.x)
	var y = int(car_grid_coordinates.y)
	if (y % 2 == 0):
		grid.up = int(car_grid_coordinates.y) + 6
	if (y % 2 == 0):
		grid.down = int(car_grid_coordinates.y) - 6
	if (x % 2 == 0):
		grid.left = int(car_grid_coordinates.x) - 6
	if (x % 2 == 0):
		grid.right = int(car_grid_coordinates.x) + 6

func add_new_tiles():
	var new_tiles = calculate_new_tiles()
	#find the tiles we need and add
	for t in new_tiles:
		if (current_tiles.find(t) == -1):
			var s = t.split(",",false,2)
			if (s[0].to_int() == 0):
				add_road(s[1].to_int(),s[0].to_int())
			else:
				if ((s[0].to_int() % 4 == 0) && (s[1].to_int() % 4 == 0)):
					add_ground(s[1].to_int(),s[0].to_int(), "ground2")
				else:
					add_ground(s[1].to_int(),s[0].to_int(), "ground1")
	#find the tiles we don't need and remove
	for t in current_tiles:
		if (new_tiles.find(t) == -1):
			remove_land(t)
	current_tiles = new_tiles.duplicate()

func _process(delta):
	car_location = Vector2(car.get_node("VehicleBody").get_transform().origin.x,car.get_node("VehicleBody").get_transform().origin.z)
	car_grid_coordinates = Vector2(-(car_location.x / (landScale)), (car_location.y / (landScale)))
	update_grid(current_grid)
	if (current_grid.values() != old_grid.values()):
		add_new_tiles()
		update_grid(old_grid)