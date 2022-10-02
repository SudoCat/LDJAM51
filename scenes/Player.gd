extends Spatial
class_name Player

signal draw_card
signal use_card

var ray_length = 10
var selected_plot
var selected_card_index
var actor
var is_human: bool
var current_turn_time = 0
var hand: Array
onready var game = get_node("/root/Game")

var brain_think_delay = 0
var rng = RandomNumberGenerator.new()

func _process(delta):
	game.time_since_start
	current_turn_time += delta
	if !is_human:
		brain(delta)
	if current_turn_time > 10:
		perform_turn()
		print("perform turn")
		current_turn_time = 0

func brain(delta):
	if current_turn_time > 10:
		brain_think_delay = rng.randf_range(0, 5)
		return
	if current_turn_time > brain_think_delay:
		make_choice()
		brain_think_delay = max(rng.randf_range(current_turn_time + 1, current_turn_time + 3), 9)
		
func make_choice():
	if rng.randf() > 0.1:
		randomize()
		hand.shuffle()
		select_card(0)
	if rng.randf() > 0.1:
		select_plot(find_desirable_plot())

func find_desirable_plot():
	var plots = game.current_district.plots
	var index = rng.randi_range(0, plots.size() - 1)
	if game.current_district.plots_claimed == plots.size():
		return
	if plots[index].claimed():
		return find_desirable_plot()
	return plots[index]

func set_offset(duration):
	print(duration)
	current_turn_time = -duration

func perform_turn():
	if selected_card_index != -1 && selected_plot:
		selected_plot.build(get_selected_card())
		use_card(selected_card_index)
	if hand.size() < 3:
		add_card(actor.draw())

func set_actor(p_actor):
	actor = p_actor
	actor.shuffle()
	add_card(actor.draw())
	add_card(actor.draw())
	
func add_card(card):
	hand.append(card)
	emit_signal("draw_card", card)

func use_card(card):
	hand.remove(card)
	selected_card_index = -1
	emit_signal("use_card", card)

func select_plot(plot):
	if selected_plot:
		selected_plot.blur()
		selected_plot.disconnect("plot_claimed", self, "on_Plot_plot_claimed")

	selected_plot = plot
	if (selected_plot):
		selected_plot.focus()
		selected_plot.connect("plot_claimed", self, "on_Plot_plot_claimed")

func on_Plot_plot_claimed():
	select_plot(null)

func select_card(card_index):
	selected_card_index = card_index

func get_selected_card():
	if selected_card_index == -1:
		return null
	return hand[selected_card_index]
