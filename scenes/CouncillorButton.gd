extends Button

var councillor

func _ready():
	self.connect("pressed", self, "_on_Self_pressed")

func set_councillor(p_councillor: Actor):
	councillor = p_councillor
	$VFlowContainer/Image.texture = councillor.image
	$VFlowContainer/Name.text = councillor.name
	$VFlowContainer/Description.text = councillor.description

func _on_Self_pressed():
	var game: Game = get_node("/root/Game")
	game.start(councillor)
