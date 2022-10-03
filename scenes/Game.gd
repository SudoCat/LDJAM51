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
var edge_size = 15;

var player_scene = load("res://scenes/Player.tscn")
var district_scene = load("res://scenes/District.tscn")

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
	hand = get_node("Interface/HandUI")
	actor_list = get_node("Interface/ActorListUI")
	current_district = $District
	prepare()
	
func _notification(notif_type):
	match notif_type:
		NOTIFICATION_WM_MOUSE_EXIT:
			can_pan = false
		NOTIFICATION_WM_MOUSE_ENTER:
			can_pan = true
	
func start(councillor):
	can_pan = true
	$Interface/CouncillorSelect.hide()
	add_district(Vector3.ZERO)
	districts["center"].district = current_district
	available_districts = districts.keys()
	available_districts.pop_front()
	var opposition = councillor.get_opposition()
	player = add_player(councillor, true)
	add_player(opposition)
	available_actors.erase(councillor)
	available_actors.erase(opposition)
	game_started = true

func start_next_district():
	var size = current_district.get_size()
	var key = available_districts[randi() % available_districts.size()]
	available_districts.erase(key)
	var position = districts["center"].district.get_neighbour_start(districts[key].index)
	districts[key].district = add_district(position)
	add_player(get_random_actor())

func add_district(position):
	var instance = district_scene.instance()
	add_child(instance)
	current_district = instance
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
	return instance

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
