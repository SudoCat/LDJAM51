extends Spatial
class_name Plot

signal plot_claimed

var game
var is_focused = false
var tween: Tween
var body: StaticBody
var mesh: MeshInstance
var pos: Vector3
var place
export var multiplier = 1.2
var rng = RandomNumberGenerator.new()
var claimed_by
var is_claimed

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
	if claimed():
		return
	if event is InputEventMouseButton:
		if event.pressed:
			game.player.select_plot(self)
			
func focus():
	if is_focused:
		return
	if !claimed():
		tween.interpolate_property(
			self, "translation:y", 
			0, 0.4,
			0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()
		show_preview_building()
	mesh.get_active_material(0).albedo_color *= multiplier
	mesh.get_active_material(1).albedo_color *= multiplier
	is_focused = true

func show_preview_building():
	var player: Player = game.player
	if player.preview_building:
		$PreviewSlot.remote_path = player.get_node("Preview").get_path()
		anchor_building_to_plot(player.preview_building)

func blur():
	if !is_focused:
		return
	tween.interpolate_property(
		self, "translation:y", 
		self.translation.y, 0, 
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	hide_preview_building()
	mesh.get_active_material(0).albedo_color /= multiplier
	mesh.get_active_material(1).albedo_color /= multiplier
	is_focused = false

func hide_preview_building():
	$PreviewSlot.remote_path = ""

func anchor_building_to_plot(instance: Spatial):
	var mesh: MeshInstance = instance.get_child(0)
	var offset = mesh.transform.xform(mesh.get_aabb()).size.y / 2
	var position = offset + 0.4
	rng.randomize()
	instance.transform.origin = Vector3(0, position, 0)
	instance.transform.basis = Basis(Vector3.UP, deg2rad(rng.randf_range(-25, 25)))

func claim(player, card):
	if !is_claimed:
		is_claimed = true
	blur()
	$Placeholder.show()
	claimed_by = player
	var mat = mesh.get_active_material(1)
	tween.interpolate_property(
			mat, "albedo_color", 
			mat.albedo_color, player.actor.plot_color,
			0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
	tween.interpolate_property(
		$Placeholder, "translation:y",
		-1, 0.9,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

func build(card: Card):
	if !is_claimed:
		return
	
	var instance: Spatial = card.building.instance()
	add_child(instance)
	anchor_building_to_plot(instance)
	place = instance
	emit_signal("plot_claimed")
	$Placeholder.hide()

func claimed():
	return is_claimed
