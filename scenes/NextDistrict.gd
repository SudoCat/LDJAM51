extends Button

func _ready():
	connect("pressed", self, "_on_Self_pressed")

func _on_Self_pressed():
	get_node("/root/Game").start_next_district()
