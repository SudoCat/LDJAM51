extends Panel

export(Array, Resource) var councillors
export(PackedScene) var button_resource

func _ready():
	build_list()
	
func build_list():
	for councillor in councillors:
		var instance = button_resource.instance()
		instance.set_councillor(councillor)
		$GridContainer.add_child(instance)
