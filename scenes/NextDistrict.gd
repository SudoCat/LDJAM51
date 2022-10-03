extends Button

func _ready():
	if name == "NextDistrict":
		connect("pressed", get_node("/root/Game"), "_on_NextDistrict_pressed")
	elif name == "Quit":
		connect("pressed", self, "_on_Self_pressed")

func _on_Self_pressed():
	var credits = get_node("../../Credits")
	credits.show()
	credits.get_node("Summary").text = ""
	
