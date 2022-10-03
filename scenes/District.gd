extends Spatial

var outer_radius = 1
var inner_radius = 0
var width = 9
var height = 9
var plots = []
var plots_claimed = 0
var full = false
var plot_scene = preload("res://scenes/grid/Plot.tscn")
var monument_card = preload("res://cards/sample_card.tres")
var district_name = ""

signal district_full()
	
func build():
	var i = 0
	var rows = height + (height + 1) % 2
	for z in range(rows):
		var distance_from_center = abs(z - ceil(rows / 2))
		var colums = width - distance_from_center
		for x in range(colums):
			create_plot(x, z, i, distance_from_center / 2)
			i += 1
	
	connect_to_plots()
	add_monument()
	reveal_plots()


func create_plot(x,z,i,offset):
	var plot = plot_scene.instance() as Plot
	var size = plot.get_xform_aabb().size
	outer_radius = size.z / 2
	inner_radius = size.x / 2
	var position = Vector3(0, 0, 0)
	position.x = (x + offset) * (inner_radius * 2)
	position.y = 0
	position.z = z * (outer_radius * 1.5)
	
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
		print(distance)
		#0.5 + 0.07 * abs(middle_index - i)
		var delay = 0.5 + 0.15 * distance
		$Tween.interpolate_property(
			plots[i], "translate:y",
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
	
	if plots_claimed >= 9:
		full = true

enum Direction { NORTH, NORTH_EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, NORTH_WEST }

func get_neighbour_start(direction):
	var x = inner_radius * 2
	var y = outer_radius * 1.5
	match direction:
		Direction.NORTH:
			return transform.origin + Vector3(7 * x, 0, 4 * y)
		Direction.NORTH_EAST:
			return transform.origin + Vector3(1, 0, 9 * y)
		Direction.SOUTH_EAST:
			return transform.origin + Vector3(-7 * x + 1, 0, 5 * y)
		Direction.SOUTH:
			return transform.origin + Vector3(-7 * x, 0, -4 * y)
		Direction.SOUTH_WEST:
			return transform.origin + Vector3(-1, 0, -9 * y)
		Direction.NORTH_WEST:
			return transform.origin + Vector3(7 * x - 1, 0, -5 * y)
	return Vector3.ONE
	

func get_size():
	return Vector3(width * inner_radius, 0, height * outer_radius)
