extends Node

var current_track = -1

func play_track(index: int):
	if index >= get_child_count():
		return
	var offset = 0;
	if current_track != -1:
		var player = get_player(current_track)
		offset = player.get_playback_position()
		player.stop()
	current_track = index
	var player = get_player(index)
	player.play(offset)

func get_player(index) -> AudioStreamPlayer:
	return get_child(index) as AudioStreamPlayer
