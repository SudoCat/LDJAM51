extends Button

func _ready():
	connect("pressed", get_node("/root/Game"), "_on_Self_pressed")

func _on_Self_pressed():
	var credits = get_node("/root/Game/Interface/Credits")
	credits.show()
	credits.get_node("Summary").text = ""
	
