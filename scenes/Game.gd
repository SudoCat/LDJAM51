extends Spatial
class_name Game

var players = []
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
var game_started = false

var player_scene = load("res://scenes/Player.tscn")

func _ready():
	hand = get_node("Interface/HandUI")
	actor_list = get_node("Interface/ActorListUI")
	current_district = $District
	prepare()
	
func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			can_pan = false
		NOTIFICATION_WM_MOUSE_ENTER:
			can_pan = true
	
func start(councillor):
	can_pan = true
	game_started = true
	player = add_player(councillor, true)
	add_player(councillor.get_opposition(), false)
	$Interface/CouncillorSelect.hide()

func prepare():
	available_actors = all_actors.duplicate()
	randomize()
	available_actors.shuffle()
	
func get_random_actor():
	return available_actors.pop_back()
	
func add_player(councillor, is_human):
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
	return instance

var edge_size = 10;

func _process(delta):
	move_viewport()
	if !game_started:
		return
	if current_district.full:
		set_process(false)
		$Interface/District_End.show()
		show_scores()
	else:
		# Game loop
		time_since_start += delta
		$Interface/Timer/DayCount.text = str('Day ', floor(time_since_start))

func show_scores():
	var scores = []
	for player in players:
		scores.append( player.evaluate_score())
	var highscore = scores.max()
	for player in players:
		player.show_score(highscore)
	
func move_viewport():
	if !can_pan:
		return
	var pos = get_viewport().get_mouse_position()
	var distance = 0.01
	var rad = deg2rad(45)
	if pos.x < edge_size:
		$Camera.transform.origin += Vector3(distance, 0, 0).rotated(Vector3.UP, rad)
	elif (pos.x > get_viewport().size.x - edge_size):
		$Camera.transform.origin += Vector3(-distance, 0, 0).rotated(Vector3.UP, rad)
	
	if pos.y < edge_size:
		$Camera.transform.origin += Vector3(0, 0, distance).rotated(Vector3.UP, rad)
	elif (pos.y > get_viewport().size.y - edge_size):
		$Camera.transform.origin += Vector3(0, 0, -distance).rotated(Vector3.UP, rad)

#func _input(event):
#	if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
