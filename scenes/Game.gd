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

var actor: Actor = load("res://actors/default.tres")

func _ready():
	player = get_node("Player")
	hand = get_node("Interface/Hand")
	
	player.set_actor(actor)
	actor.shuffle()
	hand.add_card(actor.draw())
	hand.add_card(actor.draw())
	hand.add_card(actor.draw())

var edge_size = 10;

func _process(delta):
	time_since_start += delta
	#process_turn(delta)
	
func move_viewport():
	var pos = get_viewport().get_mouse_position()
	var distance = 0.01
	if pos.x < edge_size:
		$Camera.transform.origin += Vector3(distance, 0, 0).rotated(Vector3.UP, 0)
		print("left")
	elif (pos.x > get_viewport().size.x - edge_size):
		$Camera.transform.origin += Vector3(distance, 0, 0).rotated(Vector3.UP, -135)
		print("right")
	
	if pos.y < edge_size:
		$Camera.transform.origin += Vector3(0, 0, -distance).rotated(Vector3.UP, -135)
		print("up")
	elif (pos.y > get_viewport().size.y - edge_size):
		$Camera.transform.origin += Vector3(0, 0, distance).rotated(Vector3.UP, -135)
		print("down")

func turn_start():
	pass

func turn_process(delta):
	time_this_turn += delta
	if time_this_turn > 10:
		turn_end()
		turn_start()

func turn_end():
	time_this_turn = 0

var at_edge_of_screen_time = 0

#func _input(event):
#	if event is InputEventMouseMotion:
#	   print("Mouse Motion at: ", event.position)
