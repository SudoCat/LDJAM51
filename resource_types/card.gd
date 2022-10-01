extends Resource
class_name Card

export(String) var name
export(Texture) var card_image
export(PackedScene) var building

func _init(p_name = "card", p_card_image = null, p_building = null):
	name = p_name
	card_image = p_card_image
	building = p_building
