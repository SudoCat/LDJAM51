extends Panel
class_name HandUI

var template = load("res://scenes/Card Button.tscn")

onready var container = $VFlowContainer

var cards: Dictionary

func _ready():
	var instance = template.instance()
	container.add_child(instance)
	
func use_card(card):
	for key in cards.keys():
		if card == key:
			container.remove_child(cards[key])

func add_card(card):
	var instance = template.instance()
	print('card', instance)
	instance.set_card(card)
	container.add_child(instance)
	cards[card] = instance

func _on_Player_use_card(card):
	use_card(card)

func _on_Player_draw_card(card):
	add_card(card)
