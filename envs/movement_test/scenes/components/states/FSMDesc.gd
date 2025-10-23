extends FSM
class_name FSMDescentralizado

func on_child_transition(old_state: State, new_state:State):
	if old_state != current_state:
		return
	
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
