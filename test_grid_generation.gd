extends Spatial

var district_scene = load("res://scenes/District.tscn")

var start
var districts = 0

func _ready():
	start = district_scene.instance()
	add_child(start)
	start.build()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			spawn_district()

func spawn_district():
	var d = district_scene.instance()
	var pos = start.get_neighbour_start(districts)
	d.transform.origin = pos
	add_child(d)
	districts += 1
	d.build()


#
#distance in tiles: 3
#x offset: 1
#tile_z_d: 2.309401
#z offset: 0.57735
#dir: (1, 0, 7.505553)

# 
#distance in tiles: 2
#x offset: 1
#tile_z_d: 2.309401
#z offset: 0.57735
#dir: (1, 0, 5.196152)
