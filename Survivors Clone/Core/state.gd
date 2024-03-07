extends Node

class_name State

signal transition_event(state: State, new_state_name: String)

var body: Body

func _ready():
	var _body = get_parent()
	while not _body is Body:
		_body = _body.get_parent()
		if _body == get_tree():
			break
	body = _body

func _enter():
	pass
	
func _exit():
	pass
	
func _update(_delta: float):
	pass
	
func _physics_update(_delta: float):
	pass
