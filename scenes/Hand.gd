extends Panel
class_name HandUI

var template = load("res://scenes/Card Button.tscn")

onready var container = $VFlowContainer

func add_card(card):
	var instance = template.instance()
	instance.set_card(card)
	container.add_child(instance)
