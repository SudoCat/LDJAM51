extends Spatial
class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var actors = []
var player: Player;
var hand: HandUI;

var actor: Actor = load("res://actors/default.tres")

func _ready():
	player = get_node("Player")
	hand = get_node("Interface/Hand")
	
	player.set_actor(actor)
	actor.shuffle()
	hand.add_card(actor.draw())
