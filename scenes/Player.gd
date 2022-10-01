extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ray_length = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var target = get_object_under_mouse();
	#target.
	#print(target)
	pass

func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_node("/root/Game/Camera")
	var ray_from = camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + camera.project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
