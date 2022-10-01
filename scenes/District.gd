extends Node

var outerRadius = 1
var innerRadius = 0
var width = 7
var height = 7


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var plots = []
var grass = preload("res://scenes/grid/grass.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	var rows = height + (height + 1) % 2
	for z in range(rows):
		var distance_from_center = abs(z - ceil(rows / 2))
		var colums = width - distance_from_center;
		for x in range(colums):
			create_plot(x, z, i, distance_from_center / 2)
			i += 1
			
func create_plot(x,z,i,offset):
	var plot = grass.instance()
	var mesh = plot.find_node("grass") as MeshInstance
	var size = plot.transform.xform(mesh.get_aabb()).size
	outerRadius = size.z / 2
	innerRadius = size.x / 2
	var position = Vector3(0, 0, 0)
	position.x = (x + offset) * (innerRadius * 2)
	position.y = 0;
	position.z = z * (outerRadius * 1.5);
	
	plot.transform.origin = position
	add_child(plot)
	plots.append(plot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
