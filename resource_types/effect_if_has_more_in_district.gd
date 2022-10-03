extends Resource
class_name EffectIfHasMoreInDistrict

export(String) var key
export(String) var description
export(Array,String) var side_a_related_tags
export(Array,String) var side_b_related_tags
export(int) var points

func _init(p_key = "", p_description = "", p_side_a_related_tags = [], p_side_b_related_tags= [], p_points = 0):
	key = p_key
	description = p_description
	side_a_related_tags = p_side_a_related_tags
	side_b_related_tags = p_side_b_related_tags
	points = p_points

func evaluate(plot):
	var plots = plot.district.plots
	var score = 0
	
	var count_a = 0
	var count_b = 0

	for plot in plots:
		if not plot.placed_card and not plot.claimed_by:
			continue
		
		var has_tag_a = false
		var has_tag_b = false
		
		for tag in side_a_related_tags:
			if tag in plot.placed_card.tags:
				has_tag_a = true
		
		for tag in side_b_related_tags:
			if tag in plot.placed_card.tags:
				has_tag_b = true
				
		if has_tag_a:
			count_a +=1
		if has_tag_b:
			count_b += 1
				
	if count_a > count_b:
		score += points

	return score
