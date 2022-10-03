extends Spatial
class_name Game

var players = []
var scores = []
var player
var hand
var turn = 0
var time_since_start = 0
var time_this_turn = 0
export(Array, Resource) var all_actors
var available_actors: Array
var current_district
var interface
var actor_list
var can_pan = false
var round_active = false
var edge_size = 15;
var current_round = 0
export(Texture) var cursor
export(String, MULTILINE) var intro_text
export(Array, String) var city_names
export(Array, String) var district_names
var city_name
var first_district_name

var player_scene = load("res://scenes/Player.tscn")
var district_scene = load("res://scenes/District.tscn")
var player_actor = load("res://councillors/player_councillor.tres")

var available_districts = []
var districts = {
	"center": {
		"name": "",
		"district": null
	},
	"north": {
		"name": "",
		"district": null,
		"index": 0
	},
	"north_east": {
		"name": "",
		"district": null,
		"index": 1
	},
	"south_east": {
		"name": "",
		"district": null,
		"index": 2
	},
	"south": {
		"name": "",
		"district": null,
		"index": 3
	},
	"south_west": {
		"name": "",
		"district": null,
		"index": 4
	},
	"north_west": {
		"name": "",
		"district": null,
		"index": 5
	}
}

func _ready():
	if (cursor):
		Input.set_custom_mouse_cursor(cursor)
	hand = get_node("Interface/HandUI")
	actor_list = get_node("Interface/ActorListUI")
	current_district = $District
	
	prepare()
	city_name = city_names[randi() % city_names.size()]
	first_district_name = district_names[randi() % district_names.size()]
	$Interface/Intro.text = intro_text.format({ "district_name": first_district_name, "city_name": city_name })
	$Tween.interpolate_property(
		$Interface/Intro, "modulate:a",
		0, 1,
		1, Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()
	
func _notification(notif_type):
	match notif_type:
		NOTIFICATION_WM_MOUSE_EXIT:
			can_pan = false
		NOTIFICATION_WM_MOUSE_ENTER:
			can_pan = true
	
func start(councillor):
	can_pan = true
	$Interface/CouncillorSelect.hide()
	$Interface/Intro.hide()
	add_district(first_district_name, Vector3.ZERO)
	districts["center"].district = current_district
	available_districts = districts.keys()
	available_districts.pop_front()
	var opposition = councillor.get_opposition()
	player = add_player(player_actor, true)
	add_player(councillor)
	available_actors.erase(councillor)
	available_actors.erase(opposition)
	round_active = true
	$MusicBox.play_track(0)

func _on_NextDistrict_pressed():
	if available_districts.size() == 0:
		$Interface/Credits.show()
	else:
		start_new_round()
	
func start_new_round():
	var size = current_district.get_size()
	var key = available_districts[randi() % available_districts.size()]
	available_districts.erase(key)
	var position = districts["center"].district.get_neighbour_start(districts[key].index)
	randomize()
	var district_name = district_names[randi() % district_names.size()]
	districts[key].district = add_district(district_name, position)
	add_player(get_random_actor())
	$Interface/District_End.hide()
	hide_scores()
	hand.enable()
	round_active = true
	current_round += 1
	$MusicBox.play_track(current_round)
	$Interface/CouncillorJoined/Message.text = players.back().actor.description
	$Interface/CouncillorJoined.show()
	$Tween.interpolate_property(
		$Interface/CouncillorJoined, "modulate:a",
		1, 0,
		0.3, $Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 5
	)
	$Tween.start()

func add_district(d_name, position, build = true):
	var instance = district_scene.instance()
	add_child(instance)
	current_district = instance
	current_district.district_name = d_name
	if build:
		current_district.build()
	current_district.transform.origin = position
	var camera_pos = current_district.transform.origin + Vector3(-3, 13, -7)
	$Tween.interpolate_property(
		$Camera, "translation",
		$Camera.translation, camera_pos,
		0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()
	return instance

func prepare():
	available_actors = all_actors.duplicate()
	randomize()
	available_actors.shuffle()
	
func get_random_actor():
	if available_actors.empty():
		return null
	return available_actors.pop_back()
	
func add_player(councillor, is_human = false):
	if !councillor:
		return
	var instance = player_scene.instance()
	instance.is_human = is_human
	if is_human:
		instance.connect("use_card", hand, "_on_Player_use_card")
		instance.connect("draw_card", hand, "_on_Player_draw_card")
	instance.set_actor(councillor)
	players.append(instance)
	add_child(instance)
	actor_list.add(instance)
	for i in players.size():
		players[i].set_offset(10.0 / players.size() * i)
	scores.append(0)
	return instance

func _process(delta):
	move_viewport()
	if !round_active:
		return
	if current_district.full:
		end_round()
	else:
		# Game loop
		time_since_start += delta
		$Interface/Timer/DayCount.text = str('Day ', floor(time_since_start))

func end_round():
	show_scores()
	var highscore = scores.max()
	if scores[0] == highscore:
		# player won
		$Interface/District_End/Message.text = player.actor.win_barks[current_round]
	else:
		$Interface/District_End/Message.text = player.actor.lose_barks[current_round]
	var highest_non_player = -1
	for i in scores.size():
		if i == 0:
			continue
		if highest_non_player == -1 || scores[i] > scores[highest_non_player]:
			highest_non_player = i
	$Interface/District_End/Message.text += "\n\n" + players[highest_non_player].actor.win_barks[current_round]
	$Interface/District_End.show()
	hand.disable()
	round_active = false
	player.remove_card_preview()
	player.selected_card_index = -1

func show_scores():
	for i in players.size():
		scores[i] = players[i].evaluate_score()
	
	var highscore = scores.max()
	for player in players:
		player.show_score(highscore)

func hide_scores():
	for player in players:
		player.hide_score()
	
	
func move_viewport():
	if !can_pan:
		return
	var pos = get_viewport().get_mouse_position()
	var distance = 0.01
	var rad = deg2rad(45)
	if pos.x < edge_size:
		var speed = edge_size - pos.x
		$Camera.transform.origin += Vector3(distance * speed, 0, 0).rotated(Vector3.UP, rad)
	elif (pos.x > get_viewport().size.x - edge_size):
		var speed = edge_size - (get_viewport().size.x - pos.x)
		$Camera.transform.origin += Vector3(-distance * speed, 0, 0).rotated(Vector3.UP, rad)
	
	if pos.y < edge_size:
		var speed = edge_size - pos.y
		$Camera.transform.origin += Vector3(0, 0, distance * speed).rotated(Vector3.UP, rad)
	elif (pos.y > get_viewport().size.y - edge_size):
		var speed = edge_size - (get_viewport().size.y - pos.y)
		$Camera.transform.origin += Vector3(0, 0, -distance * speed).rotated(Vector3.UP, rad)

#func _input(event):
#	if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
