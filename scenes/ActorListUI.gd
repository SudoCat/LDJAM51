extends Panel
class_name ActorListUI

var template = load("res://scenes/ActorImage.tscn")
onready var container = $VFlowContainer2

func add(player):
	var actor = player.actor
	var instance = template.instance()
	instance.set_actor(actor)
	container.add_child(instance)
	player.avatar_ui = instance
