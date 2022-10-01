extends Resource
class_name Actor

export(String) var name
export(Texture) var image
export(Array, Resource) var deck

var active_deck: Array

func _init(p_name = "card", p_image = null, p_deck = []):
	name = p_name
	image = p_image
	deck = p_deck

func shuffle():
	active_deck = deck
	active_deck.shuffle()

func draw():
	return active_deck.pop_back()
