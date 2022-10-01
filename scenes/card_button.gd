extends TextureButton
class_name CardButton

var card: Card
onready var game = get_node("/root/Game")

func set_card(p_card: Card):
	card = p_card
	self.texture_normal = card.card_image
	self.connect("pressed", self, "_on_Self_pressed")
	
func _on_Self_pressed():
	var plot: Plot = game.player.selected
	if plot && !plot.claimed():
		plot.build(card)
		game.player.select_plot(null)
