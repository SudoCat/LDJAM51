extends Spatial
class_name Plot

signal plot_claimed

var game
var district
var index
var is_focused = false
var tween: Tween
var body: StaticBody
var mesh: MeshInstance
var pos: Vector3
var place
var placed_card
export var multiplier = 1.2
var rng = RandomNumberGenerator.new()
var claimed_by

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
	focus()
	
func _on_Body_mouse_exited():
	blur()

func _on_Body_input_event(camera, event, position, normal, shape_idx):
	if !game.round_active || district != game.current_district || claimed():
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
	elif place:
		tween.interpolate_property(
			$CardPreview, "scale:x",
			0, 1,
			0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			$CardPreview, "scale:y",
			0, 1,
			0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
		)
		tween.start()
	mesh.get_active_material(0).albedo_color *= multiplier
	mesh.get_active_material(1).albedo_color *= multiplier
	is_focused = true

func show_preview_building():
	var player: Player = game.player
	if player && player.preview_building:
		$PreviewSlot.remote_path = player.get_node("Preview").get_path()
		anchor_building_to_plot(player.preview_building)
		player.preview_building.show()

func blur():
	if !is_focused:
		return
	tween.interpolate_property(
		self, "translation:y", 
		self.translation.y, 0, 
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		$CardPreview, "scale:x",
		$CardPreview.scale.x, 0,
		0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		$CardPreview, "scale:y",
		$CardPreview.scale.y, 0,
		0.2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
	)
	tween.start()
	hide_preview_building()
	mesh.get_active_material(0).albedo_color /= multiplier
	mesh.get_active_material(1).albedo_color /= multiplier
	is_focused = false

func hide_preview_building():
	$PreviewSlot.remote_path = ""
	var player: Player = game.player
	if player && player.preview_building:
		player.preview_building.hide()

func anchor_building_to_plot(instance: Spatial):
	var mesh: MeshInstance = instance.get_child(0)
	var offset = mesh.transform.xform(mesh.get_aabb()).size.y / 2
	var position = offset + 0.4
	rng.randomize()
	instance.transform.origin = Vector3(0, position, 0)
	instance.transform.basis = Basis(Vector3.UP, deg2rad(rng.randf_range(-25, 25)))

func claim(player, card):
	if claimed():
		return
	claimed_by = player
	claimed_by.claimed.append(self)
	set_card(card)
	blur()
	($Placeholder/MeshInstance.material_override as SpatialMaterial).albedo_texture = player.actor.hoarding
	$Placeholder.show()
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

func set_card(card: Card):
	placed_card = card
	$"Viewport/Popup/Label".text = card.description

func build(card: Card):
	set_card(card)
	var instance: Spatial = card.building.instance()
	add_child(instance)
	anchor_building_to_plot(instance)
	place = instance
	emit_signal("plot_claimed")
	tween.interpolate_property(
		$Placeholder, "translation:y",
		0.9, -1,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	
	if claimed_by:
		print('score', evaluate_score())
	
func evaluate_score():
	return placed_card.evaluate_score(self)
	
func get_nearby(plot_radius):
	var search_area = self.get_node('DetectNearbyPlots')
	var search_area_collision_shape = search_area.get_node('CollisionShape')
	search_area_collision_shape.get_shape().radius = plot_radius + 1

	var all_overlapping_plots = search_area.get_overlapping_bodies()
	var overlapping_plots = []

	for plot in all_overlapping_plots:
		if plot != self.get_node('StaticBody'):
			overlapping_plots.append(plot.get_parent())

	return overlapping_plots

func claimed():
	return claimed_by || place
