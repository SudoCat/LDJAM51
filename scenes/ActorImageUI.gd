extends Control

var prev_score = 0

func set_actor(actor):
	$Image.texture = actor.image
	$CouncillorName.text = actor.name

func set_score(score, is_highscore):
	$Tween.interpolate_method(self, "tally_score", prev_score, score, 1, Tween.TRANS_EXPO, Tween.EASE_IN, 0.5)
	$Score.show()
	$Tween.start()
	prev_score = score
	
	if is_highscore:
		$WinnerGetsTheCrown.show()
		
func tally_score(score):
	$Score/Label.text = str(round(score))

func hide_score():
	$Score.hide()
	$WinnerGetsTheCrown.hide()

func set_turn_time(time):
	$ProgressBar.value = time
