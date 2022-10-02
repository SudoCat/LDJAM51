extends Resource
class_name Actor

export(String) var name
export(Texture) var image
export(Resource) var deck
#export(Dictionary) var traits
#export(float, 0, 10, 0.1) var decisiveness
#export(float, 0, 10, 0.1) var thoughtfulness
export(Color) var plot_color

var active_deck: Array

func _init(p_name = "card", p_image = null, p_deck = []):
	name = p_name
	image = p_image
	deck = p_deck

func shuffle():
	active_deck = deck.cards.duplicate()
	randomize()
	active_deck.shuffle()

func draw():
	if active_deck.empty():
		shuffle()
	return active_deck.pop_back()
