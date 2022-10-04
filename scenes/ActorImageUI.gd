extends Control

var prev_score = 0
var last_bark = 0

func set_actor(actor):
	$Image.texture = actor.image
	$CouncillorName.text = actor.name

func set_score(score, is_highscore):
	$Tween.interpolate_method(self, "tally_score", prev_score, score, 1, Tween.TRANS_EXPO, Tween.EASE_IN, 0.5)
	$Score.show()
	$Tween.start()
	prev_score = score
	
	if is_highscore:
		$Rosette.show()
		
func tally_score(score):
	$Score/Label.text = str(round(score))

func hide_score():
	$Score.hide()
	$Rosette.hide()

func set_turn_time(time):
	$ProgressBar.value = time
	
func bark(text):
	if last_bark + 2000 > Time.get_ticks_msec():
		return
	last_bark = Time.get_ticks_msec()
	$Tween.interpolate_property(
		$Barks, "modulate:a",
		0, 1,
		0.1, $Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.interpolate_property(
		$Barks, "modulate:a",
		1, 0,
		0.1, $Tween.TRANS_LINEAR, Tween.EASE_IN, 2
	)
	$Barks/Label.text = text
	$Tween.start()
