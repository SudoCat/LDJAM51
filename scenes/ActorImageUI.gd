extends Node2D


func set_score(score, is_highscore):
	$Score/Label.text = str(score)
	$Score.show()
	
	if is_highscore:
		$WinnerGetsTheCrown.show()
