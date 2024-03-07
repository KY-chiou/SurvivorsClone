extends Node

class_name AttackImpl

@export var attackResource: Resource
@export var ammo := 0
@export var level := 1

var body: Node

func _ready():
	body = get_parent()
	while not body is Body:
		body = body.get_parent()
		if body == get_tree():
			break
			
func _create_instance() -> Attack:
	return null
