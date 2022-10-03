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
var claimed: Array
var avatar_ui
onready var game = get_node("/root/Game")

var brain_think_delay = 0
var rng = RandomNumberGenerator.new()

func _process(delta):
	if !game.round_active:
		return
	current_turn_time += delta
	if !is_human:
		brain()
	if current_turn_time > 10:
		perform_turn()
		current_turn_time = 0
	avatar_ui.set_turn_time(current_turn_time)

func set_offset(duration):
	current_turn_time = -duration
	avatar_ui.set_turn_time(0)

func perform_turn():
	# build plot and use card
	if selected_card_index != -1 && selected_plot:
		selected_plot.build(get_selected_card())
		use_card(selected_card_index)
		selected_plot = null
		play_bark(actor.build_barks)
			
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
		play_bark(actor.claim_barks)
			
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
	if !preview_building:
		return
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
	if rng.randf() > 0.2:
		randomize()
		hand.shuffle()
		select_card(0)
	if selected_card_index != -1 && rng.randf() > 0.2:
		select_plot(find_desirable_plot())

func find_desirable_plot():
	var plots = game.current_district.plots
	var index = rng.randi_range(0, plots.size() - 1)
	if game.current_district.plots_claimed == plots.size():
		return
	if plots[index].claimed():
		return find_desirable_plot()
	return plots[index]


func show_score(highscore):
	var score = evaluate_score()
	var is_highscore = score == highscore
	avatar_ui.set_score(score, is_highscore)
	
func hide_score():
	avatar_ui.hide_score()

func evaluate_score():
	var score = 0
	for plot in claimed:
		if plot.district != game.current_district:
			score += plot.evaluate_score()
	return score

func play_win_bark():
	play_bark(actor.lose_barks)

func play_loss_bark():
	play_bark(actor.lose_barks)

func play_bark(list):
	if !list || list.empty():
		return
	if rng.randf() < 1:
		var bark = list[rng.randi() % list.size()]
		avatar_ui.bark(bark.format({ 
			"district_name": game.current_district.district_name, 
			"city_name": game.city_name 
		}))
