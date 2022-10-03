extends Resource
class_name Actor

export(String) var name
export(String, MULTILINE) var description
export(Texture) var image
export(Texture) var hoarding
export(Resource) var deck
#export(Dictionary) var traits
#export(float, 0, 10, 0.1) var decisiveness
#export(float, 0, 10, 0.1) var thoughtfulness
export(float, 0, 1, 0.05) var talkativeness
export(Color) var plot_color
export(String, FILE, "*.tres") var opposition
export(Array, String) var claim_barks
export(Array, String) var build_barks
export(Array, String, MULTILINE) var win_barks
export(Array, String, MULTILINE) var lose_barks

var active_deck: Array

func _init(p_name = "councillor", p_description = "", p_image = null, p_deck = [], p_plot_color = Color.aquamarine, p_opposition = ""):
	name = p_name
	description = p_description
	image = p_image
	deck = p_deck
	plot_color = p_plot_color
	opposition = p_opposition

func shuffle():
	active_deck = deck.cards.duplicate()
	randomize()
	active_deck.shuffle()

func draw():
	if active_deck.empty():
		shuffle()
	return active_deck.pop_back()

func get_opposition() -> Actor:
	return load(opposition) as Actor
