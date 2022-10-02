extends Resource
class_name EffectHasBuildingNearBy

export(String) var key
export(String) var description
export(Array,String) var related_tags
export(int) var points
export(int) var tile_area_of_affect

func _init(p_key = "", p_description = "", p_related_tags = [], p_points = 0, p_tile_area_of_affect = 0):
	key = p_key
	description = p_description
	related_tags = p_related_tags
	points = p_points
	tile_area_of_affect = p_tile_area_of_affect

func evaluate(plot):
	var nearby_plots = plot.get_nearby(tile_area_of_affect)
	var score = 0

	for plot in nearby_plots:
		if not plot.placed_card:
			continue
		
		for tag in related_tags:
			print(tag, plot.placed_card.tags)
			if tag in plot.placed_card.tags:
				score += points

	return score
