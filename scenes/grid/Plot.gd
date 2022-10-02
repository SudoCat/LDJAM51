extends Spatial
class_name Plot

var game
var is_focused = false
var tween: Tween
var body: StaticBody
var mesh: MeshInstance
var pos: Vector3
var place
export var multiplier = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_node("/root/Game")
	tween = $Tween
	mesh = $grass/tmpParent/grass
	body = $StaticBody
	pos = transform.origin
	body.connect("mouse_entered", self, "_on_Body_mouse_entered")
	body.connect("mouse_exited", self, "_on_Body_mouse_exited")
	body.connect("input_event", self, "_on_Body_input_event")
	
func get_xform_aabb():
	return $grass.transform.xform($grass/tmpParent/grass.get_aabb())

func _on_Body_mouse_entered():
	if game.player.selected_plot != self:
		focus()
	
func _on_Body_mouse_exited():
	if game.player.selected_plot != self:
		blur()

func _on_Body_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			game.player.select_plot(self)
			
func focus():
	if is_focused:
		return
	tween.interpolate_property(
		self, "translation:y", 
		0, 0.4,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	mesh.get_active_material(0).albedo_color *= multiplier
	mesh.get_active_material(1).albedo_color *= multiplier
	is_focused = true

func blur():
	if !is_focused:
		return
	tween.interpolate_property(
		self, "translation:y", 
		self.translation.y, 0, 
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	mesh.get_active_material(0).albedo_color /= multiplier
	mesh.get_active_material(1).albedo_color /= multiplier
	is_focused = false
	
func build(card: Card):
	var instance: Spatial = card.building.instance()
	add_child(instance)
	var mesh: MeshInstance = instance.get_child(0)
	var offset = mesh.transform.xform(mesh.get_aabb()).size.y / 2
	var position = offset + 0.4
	instance.translate(Vector3(0, position, 0))

func claimed():
	return place != null
