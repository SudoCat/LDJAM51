extends Button

func _ready():
	connect("pressed", get_node("/root/Game"), "_on_NextDistrict_pressed")
