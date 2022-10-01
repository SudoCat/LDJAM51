extends Spatial

var selected = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	var body = get_node("StaticBody")
	body.connect("mouse_entered", self, "_on_Body_mouse_entered")
	body.connect("mouse_exited", self, "_on_Body_mouse_exited")

func _on_Body_mouse_entered():
	self.translate(Vector3(0, 0.2, 0))
	
func _on_Body_mouse_exited():
	self.translate(Vector3(0, -0.2, 0))
