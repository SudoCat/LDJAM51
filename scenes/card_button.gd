extends TextureButton
class_name CardButton

var card: Card
onready var game: Game = get_node("/root/Game")

func set_card(p_card: Card):
	card = p_card
	self.texture_normal = card.card_image
	self.connect("pressed", self, "_on_Self_pressed")
	
func _on_Self_pressed():
	if game.player.selected && !game.player.selected.claimed():
		game.player.selected.build(card)
