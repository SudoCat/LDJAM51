extends Spatial
class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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

var player_scene = load("res://scenes/Player.tscn")

func _ready():
	hand = get_node("Interface/HandUI")
	actor_list = get_node("Interface/ActorListUI")
	current_district = $District
	prepare()
	
	player = add_player(true)
	add_player(false)
	add_player(false)
	add_player(false)

func prepare():
	available_actors = all_actors.duplicate()
	randomize()
	available_actors.shuffle()
	
func add_player(is_human):
	var instance = player_scene.instance()
	instance.is_human = is_human
	if is_human:
		instance.connect("use_card", hand, "_on_Player_use_card")
		instance.connect("draw_card", hand, "_on_Player_draw_card")
	var actor = available_actors.pop_back()
	instance.set_actor(actor)
	players.append(instance)
	add_child(instance)
	actor_list.add(instance.actor)
	for i in players.size():
		players[i].set_offset(10.0 / players.size() * i)
	return instance

var edge_size = 10;

func _process(delta):
	if current_district.full:
		$Interface/District_End.show()
		set_process(false)
	else:
		# Game loop
		time_since_start += delta
		$Interface/Timer/DayCount.text = str('Day ', ceil(time_since_start))
	
func move_viewport():
	var pos = get_viewport().get_mouse_position()
	var distance = 0.01
	if pos.x < edge_size:
		$Camera.transform.origin += Vector3(distance, 0, 0).rotated(Vector3.UP, 0)
	elif (pos.x > get_viewport().size.x - edge_size):
		$Camera.transform.origin += Vector3(distance, 0, 0).rotated(Vector3.UP, -135)
	
	if pos.y < edge_size:
		$Camera.transform.origin += Vector3(0, 0, -distance).rotated(Vector3.UP, -135)
	elif (pos.y > get_viewport().size.y - edge_size):
		$Camera.transform.origin += Vector3(0, 0, distance).rotated(Vector3.UP, -135)

#func _input(event):
#	if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
