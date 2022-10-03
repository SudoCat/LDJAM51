extends Panel
class_name ActorListUI

var template = load("res://scenes/ActorImage.tscn")
onready var container = $VFlowContainer2

func add(player):
	var actor = player.actor
	var instance = template.instance()
	instance.get_node('Image').texture = actor.image
	instance.move_local_x(container.get_child_count() * 146)
	container.add_child(instance)
	player.avatar_ui = instance
