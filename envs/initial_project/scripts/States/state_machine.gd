extends Node
class_name  FSM

@export var initial_state: State 

var current_state: State
var states : Dictionary = {}

func init(parent: CharacterBody2D):
	for child in get_children():
		if child is State:
			child.parent = parent
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if !current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state

##Interrompe um estado para ir para outro. para ser usado fora do state machine
func change_state(new_state_name: String):
	if current_state:
		current_state.Exit()
	current_state = get_node(new_state_name)
	if current_state:
		current_state.Enter()
