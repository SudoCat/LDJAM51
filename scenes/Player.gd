extends Spatial
class_name Player

signal draw_card
signal use_card

var ray_length = 10
var selected_plot
var selected_card_index = -1
var actor
var is_human: bool
var current_turn_time = 0
var hand: Array
var preview_building: Spatial
onready var game = get_node("/root/Game")

var brain_think_delay = 0
var rng = RandomNumberGenerator.new()

func _process(delta):
	if game.current_district.full:
		return
	current_turn_time += delta
	if !is_human:
		brain()
	if current_turn_time > 10:
		perform_turn()
		current_turn_time = 0

func set_offset(duration):
	current_turn_time = -duration

func perform_turn():
	# build plot and use card
	if selected_card_index != -1 && selected_plot:
		selected_plot.build(get_selected_card())
		use_card(selected_card_index)
		selected_plot = null
	# draw new card
	if hand.size() < 3:
		draw_card()
	# re-enable deck
	if is_human:
		game.hand.enable()

func set_actor(p_actor):
	actor = p_actor
	actor.shuffle()
	draw_card()
	draw_card()
	draw_card()



func select_plot(plot):
	if selected_card_index == -1:
		return

	if selected_plot:
		return
		if is_human:
			selected_plot.blur()
		#selected_plot.disconnect("plot_claimed", self, "on_Plot_plot_claimed")

	selected_plot = plot
	if (selected_plot):
		if is_human:
			selected_plot.focus()
			remove_card_preview()
			game.hand.disable()
		selected_plot.claim(self, get_selected_card())
		#selected_plot.connect("plot_claimed", self, "on_Plot_plot_claimed")

func on_Plot_plot_claimed():
	select_plot(null)



func draw_card():
	var card: Card = actor.draw()
	hand.append(card)
	emit_signal("draw_card", card)

func use_card(card_index):
	hand.remove(card_index)
	selected_card_index = -1
	emit_signal("use_card", card_index)

func select_card(card_index):
	selected_card_index = card_index
	if is_human:
		spawn_card_preview()
	
func get_selected_card():
	if selected_card_index == -1:
		return null
	return hand[selected_card_index]

func spawn_card_preview():
	if preview_building:
		remove_card_preview()
	if selected_card_index == -1:
		return
	var card: Card = hand[selected_card_index]
	preview_building = card.building.instance()
	preview_building.transform.origin = Vector3(1000, 1000, 1000)
	$Preview.add_child(preview_building)
	
func remove_card_preview():
	preview_building.queue_free()
	preview_building = null
	$Preview.transform.origin = Vector3(100, 1000, 1000)





func brain():
	if selected_plot:
		return
	if current_turn_time > 10:
		brain_think_delay = rng.randf_range(0, 2)
		return
	if current_turn_time > brain_think_delay:
		make_choice()
		brain_think_delay = max(rng.randf_range(current_turn_time + 1, current_turn_time + 3), 9)
		
func make_choice():
	if rng.randf() > 0.1:
		randomize()
		hand.shuffle()
		select_card(0)
	if selected_card_index != -1 && rng.randf() > 0.1:
		select_plot(find_desirable_plot())

func find_desirable_plot():
	var plots = game.current_district.plots
	var index = rng.randi_range(0, plots.size() - 1)
	if game.current_district.plots_claimed == plots.size():
		return
	if plots[index].claimed():
		return find_desirable_plot()
	return plots[index]
