extends Spatial
class_name Player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ray_length = 10
var selected_plot
var selected_card
var actor

func set_actor(p_actor):
	actor = p_actor

func select_plot(plot):
	if selected_plot:
		selected_plot.blur()
		if selected_plot == plot:
			selected_plot = null
			return

	if (plot):
		plot.focus()

	selected_plot = plot

func select_card(card):
	selected_card = card
