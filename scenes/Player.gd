extends Spatial
class_name Player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ray_length = 10
var selected
var actor: Actor

func set_actor(p_actor: Actor):
	actor = p_actor

func select_plot(plot):
	if selected:
		selected.selected = false
		selected.blur()
		if selected == plot:
			selected = null
			return

	plot.selected = true
	selected = plot
