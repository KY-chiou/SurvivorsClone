extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition_event.connect(on_child_transition)
			
	if initial_state:
		initial_state._enter()
		current_state = initial_state
			
func _process(delta):
	if current_state:
		current_state._update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state._physics_update(delta)

func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
		
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state._exit()
		
	new_state._enter()
	current_state = new_state
	
