extends Button

func _ready():
	connect("pressed", self, "_on_Self_pressed")

func _on_Self_pressed():
	var credits = get_node("../../Credits")
	credits.show()
	credits.get_node("Summary").text = ""
	
