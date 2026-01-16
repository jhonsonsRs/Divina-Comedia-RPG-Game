extends CSAction
class_name CSAction_PlayAudio

var audio_player: AudioStreamPlayer
var wait_finish: bool = true 

func play(player: Node) -> void:
	if audio_player:
		audio_player.play()
		if wait_finish:
			await audio_player.finished
