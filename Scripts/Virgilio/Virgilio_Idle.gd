extends VirgilioState

func enter():
	virgilio.animation_tree["parameters/playback"].travel("idle")
	
func update(_delta):
	if virgilio.velocity.length() > 2:
		virgilio.state_machine.change_state(virgilio.state_machine.get_node("Follow"))
