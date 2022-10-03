extends Resource
class_name Card

export(String) var name
export(String, MULTILINE) var description
export(Texture) var card_image
export(PackedScene) var building
export(Array,Resource) var effects
export(Array,String) var tags
export(int) var base_points

func _init(p_name = "card", p_description = "", p_card_image = null, p_building = null, p_effects = [], p_tags = [], p_base_points = 0):
	name = p_name
	description = p_description
	card_image = p_card_image
	building = p_building
	effects = p_effects
	tags = p_tags
	base_points = p_base_points

func evaluate_score(plot):
	var score = base_points
	for effect in effects:
		score += effect.evaluate(plot)
	return score
