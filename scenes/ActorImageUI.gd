extends Control

func set_actor(actor):
	$Image.texture = actor.image
	$CouncillorName.text = actor.name

func set_score(score, is_highscore):
	$Score/Label.text = str(score)
	$Score.show()
	
	if is_highscore:
		$WinnerGetsTheCrown.show()

func set_turn_time(time):
	$ProgressBar.value = time
