extends Node

var outerRadius = 1
var innerRadius = 0
var width = 7
var height = 7
var plots = []
var plot_scene = preload("res://scenes/grid/Plot.tscn")
var monument_card = preload("res://cards/sample_card.tres")

func _ready():
	var i = 0
	var rows = height + (height + 1) % 2
	for z in range(rows):
		var distance_from_center = abs(z - ceil(rows / 2))
		var colums = width - distance_from_center
		for x in range(colums):
			create_plot(x, z, i, distance_from_center / 2)
			i += 1
			
	add_monument()
			
			
func create_plot(x,z,_i,offset):
	var plot = plot_scene.instance() as Plot
	var size = plot.get_xform_aabb().size
	outerRadius = size.z / 2
	innerRadius = size.x / 2
	var position = Vector3(0, 0, 0)
	position.x = (x + offset) * (innerRadius * 2)
	position.y = 0
	position.z = z * (outerRadius * 1.5)
	
	plot.transform.origin = position
	add_child(plot)
	plots.append(plot)
	
	
func add_monument():
	print(plots.size())
	var middle = ceil(plots.size()/2)
	plots[middle].build(monument_card)
	
