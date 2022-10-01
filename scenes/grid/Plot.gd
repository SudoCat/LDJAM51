extends Spatial
class_name Plot

var selected = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	var body = get_node("StaticBody")
	body.connect("mouse_entered", self, "_on_Body_mouse_entered")
	body.connect("mouse_exited", self, "_on_Body_mouse_exited")
	body.connect("input_event", self, "_on_Body_input_event")

func _on_Body_mouse_entered():
	if !selected:
		self.translate(Vector3(0, 0.2, 0))
	
func _on_Body_mouse_exited():
	if !selected:
		self.translate(Vector3(0, -0.2, 0))

func _on_Body_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selected = !selected
