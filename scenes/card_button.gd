extends TextureButton
class_name CardButton

var card: Card
onready var game = get_node("/root/Game")

func set_card(p_card: Card):
	card = p_card
	$Image.texture = card.card_image
	self.connect("pressed", self, "_on_Self_pressed")

func _on_Self_pressed():
	game.player.select_card(self.get_index())
