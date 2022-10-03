extends TextureButton
class_name CardButton

var card: Card
var show_details = false
onready var game = get_node("/root/Game")
export(bool) var show_only_details = false

func set_card(p_card: Card):
	card = p_card
	$Image.texture = card.card_image
	$Info/VFlowContainer/Description.text = card.description
	if show_only_details:
		$Info.show_behind_parent = false
		$Info.show()
	else:
		self.connect("toggled", self, "_on_Self_toggle")
		self.connect("mouse_entered", self, "_on_Self_mouse_entered")
		self.connect("mouse_exited", self, "_on_Self_mouse_exited")

func toggle(is_disabled):
	disabled = is_disabled
	if is_disabled:
		close_details()
		set_pressed_no_signal(false)

func _on_Self_toggle(pressed):
	if pressed:
		game.player.select_card(self.get_index())
		open_details()
	else:
		close_details()

func _on_Self_mouse_entered():
	if !pressed:
		open_details()

func _on_Self_mouse_exited():
	if !pressed:
		close_details()

func open_details(delay = 0):
	show_details = true
	$Info.show()
	$Tween.interpolate_property(
		$Info, "modulate:a",
		0, 1, 
		0.15, $Tween.TRANS_CIRC, $Tween.EASE_IN_OUT, delay
	)
	$Tween.start()

func close_details():
	show_details = false
	$Tween.interpolate_property(
		$Info, "modulate:a",
		1, 0,
		0.15, $Tween.TRANS_CIRC, $Tween.EASE_IN_OUT
	)
	$Tween.interpolate_callback($Info, 0.15, "hide")
	$Tween.start()
	
