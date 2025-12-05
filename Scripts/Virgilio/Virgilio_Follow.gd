extends VirgilioState

func enter():
	virgilio.animation_tree["parameters/playback"].travel("run")
	
func update(_delta):
	if virgilio.velocity.length() <= 2  or virgilio.can_follow_player == false:
		virgilio.state_machine.change_state(virgilio.state_machine.get_node("Idle"))
