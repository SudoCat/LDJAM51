extends Panel
class_name HandUI

var template = load("res://scenes/Card Button.tscn")

onready var container = $VFlowContainer

func _ready():
	var instance = template.instance()

func remove_card(index):
	var card_button: CardButton = container.get_child(index)
	$Tween.interpolate_property(
		card_button, "rect_position:x",
		card_button.rect_position.x, -300,
		0.3, Tween.TRANS_QUINT, Tween.EASE_IN_OUT
	)
	$Tween.interpolate_callback(container, 0.2, "remove_child", card_button)
	for i in container.get_child_count():
		if i <= index:
			continue
		var child: CardButton = container.get_child(i);
		$Tween.interpolate_property(
			child, "rect_position:y",
			child.rect_position.y, child.rect_position.y - child.rect_size.y - 40,
			0.3, Tween.TRANS_QUINT, Tween.EASE_IN_OUT
		)
	$Tween.start()

func add_card(card):
	var instance: CardButton = template.instance()
	instance.modulate.a = 0
	instance.set_card(card)
	container.add_child(instance)
	$Tween.interpolate_property(
		instance, "modulate:a",
		0, 1,
		0.3, Tween.TRANS_QUINT, Tween.EASE_IN_OUT, 0.3
	)
	$Tween.start()

func _on_Player_use_card(index):
	remove_card(index)

func _on_Player_draw_card(card):
	add_card(card)

func disable():
	toggle_disabled(true)
		
func enable():
	toggle_disabled(false)
		
func toggle_disabled(disabled):
	var count = container.get_child_count()
	for i in count:
		var btn = container.get_child(i) as CardButton
		btn.toggle(disabled)
