extends Spatial

var outer_radius = 1
var inner_radius = 0
var size = 7
var plots = []
var plots_claimed = 0
var full = false
var plot_scene = preload("res://scenes/grid/Plot.tscn")
var monument_card = preload("res://cards/sample_card.tres")
var district_name = ""
var center_position = Vector3(0,0,0)

signal district_full()
	
func build():
	calculate_plot_radius()
	var center_coord = ceil(size/2)
	center_position = calculate_position(center_coord, center_coord, inner_radius, outer_radius)

	var i = 0
	# ensure size is odd number
	#size + (size + 1) % 2
	for z in range(size):
		var distance_from_center = abs(z - ceil(size / 2))
		var colums = size - distance_from_center
		for x in range(colums):
			create_plot(x, z, i, distance_from_center / 2)
			i += 1
	
	connect_to_plots()
	add_monument()
	reveal_plots()
	
func calculate_plot_radius():
	var plot = plot_scene.instance() as Plot
	var size = plot.get_xform_aabb().size
	outer_radius = size.z / 2
	inner_radius = size.x / 2
	plot.queue_free()

func calculate_position(x, z, irad, orad):
	var position = Vector3(0, 0, 0)
	position.x = x * (irad * 2)
	position.y = 0
	position.z = z * (orad * 1.5)
	return position

func create_plot(x,z,i,offset):
	var plot = plot_scene.instance() as Plot
	var position = calculate_position(x+offset, z, inner_radius, outer_radius)
	position -= center_position
	
	plot.transform.origin = position
	plot.scale = Vector3.ZERO
	plot.index = i
	plot.district = self
	add_child(plot)
	plots.append(plot)

func reveal_plots():
	var middle_index = ceil(plots.size()/2)
	var middle: Plot = plots[middle_index]
	var max_distance = middle.transform.origin.distance_to(plots[0].transform.origin)
	for i in plots.size():
		var plot: Plot = plots[i]
		var distance = middle.transform.origin.distance_to(plot.transform.origin) / max_distance
		var delay = 0.5 + 0.15 * distance
		$Tween.interpolate_property(
			plots[i], "translation:y",
			-2, 0,
			0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, delay
		)
		$Tween.interpolate_property(
			plots[i], "scale",
			Vector3.ZERO, Vector3.ONE,
			0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay
		)
		$Tween.start()

func connect_to_plots():
	for plot in plots:
		plot.connect("plot_claimed", self, "on_Plot_plot_claimed")

func add_monument():
	var middle = ceil(plots.size()/2)
	plots[middle].build(monument_card)

func on_Plot_plot_claimed():
	plots_claimed += 1
	
	if plots_claimed >= plots.size():
		full = true

enum Direction { NORTH, NORTH_EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, NORTH_WEST }

var count = 0

func get_neighbour_start(direction):
	var outer_radius_distance = size/2.0 + size
	var z = outer_radius_distance * outer_radius
	var dir = Vector3(size % 2, 0, z)
	match direction:
		Direction.NORTH:
			return transform.translated(dir).origin
		Direction.NORTH_EAST:
			return transform.translated(dir.rotated(Vector3.UP, deg2rad(60))).origin
		Direction.SOUTH_EAST:
			return transform.translated(dir.rotated(Vector3.UP, deg2rad(120))).origin
		Direction.SOUTH:
			return transform.translated(dir.rotated(Vector3.UP, deg2rad(180))).origin
		Direction.SOUTH_WEST:
			return transform.translated(dir.rotated(Vector3.UP, deg2rad(240))).origin
		Direction.NORTH_WEST:
			return transform.translated(dir.rotated(Vector3.UP, deg2rad(300))).origin
	return Vector3.ONE
