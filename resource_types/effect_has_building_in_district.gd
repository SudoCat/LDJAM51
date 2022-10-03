extends Resource
class_name EffectHasBuildingInDistrict

export(String) var key
export(String) var description
export(Array,String) var related_tags
export(int) var points

func _init(p_key = "", p_description = "", p_related_tags = [], p_points = 0):
	key = p_key
	description = p_description
	related_tags = p_related_tags
	points = p_points

func evaluate(plot):
	var plots = plot.district.plots
	var score = 0
	
	for plot in plots:
		if not plot.placed_card and not plot.claimed_by:
			continue
		
		for tag in related_tags:
			if tag in plot.placed_card.tags:
				score += points

	return score
