extends Spatial
class_name Plot

var game
var selected = false
var tween: Tween
var body: StaticBody
var mesh: MeshInstance
var mat: SpatialMaterial
var base_color: Color
var pos: Vector3
var place
export var multiplier = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/Game")
	tween = $Tween
	mesh = $tmpParent/grass
	body = $StaticBody
	mat = mesh.get_surface_material(1).duplicate()
	mesh.set_surface_material(1, mat)
	base_color = mat.albedo_color
	pos = transform.origin
	body.connect("mouse_entered", self, "_on_Body_mouse_entered")
	body.connect("mouse_exited", self, "_on_Body_mouse_exited")
	body.connect("input_event", self, "_on_Body_input_event")

func _on_Body_mouse_entered():
	if game.player.selected != self:
		focus()
	
func _on_Body_mouse_exited():
	if game.player.selected != self:
		blur()

func _on_Body_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			game.player.select_plot(self)
			
func focus():
	tween.interpolate_property(
		self, "translation:y", 
		0, 0.4,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	mesh.get_active_material(0).albedo_color *= multiplier
	mesh.get_active_material(1).albedo_color *= multiplier

func blur():
	tween.interpolate_property(
		self, "translation:y", 
		self.translation.y, 0, 
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	mesh.get_active_material(0).albedo_color /= multiplier
	mesh.get_active_material(1).albedo_color /= multiplier
	
func build(card: Card):
	var instance: Spatial = card.building.instance()
	add_child(instance)
	var mesh: MeshInstance = instance.get_child(0)
	var offset = mesh.transform.xform(mesh.get_aabb()).size.y / 2
	var position = offset + 0.2
	instance.translate(Vector3(0, position, 0))

func claimed():
	return place != null
