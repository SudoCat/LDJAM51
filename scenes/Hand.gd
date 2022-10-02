extends Panel
class_name HandUI

var template = load("res://scenes/Card Button.tscn")

onready var container = $VFlowContainer

func _ready():
	var instance = template.instance()

func remove_card(index):
	container.remove_child(container.get_child(index))

func add_card(card):
	var instance = template.instance()
	instance.set_card(card)
	container.add_child(instance)

func _on_Player_use_card(index):
	remove_card(index)

func _on_Player_draw_card(card):
	add_card(card)
