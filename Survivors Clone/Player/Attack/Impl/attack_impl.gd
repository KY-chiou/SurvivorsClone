extends Node

class_name AttackImpl

@export var attackResource: Resource
@export var ammo := 0
@export var level := 1

var body: Node

var additional_attacks: int:
	get:
		return 0 if not body is Player else (body as Player).additional_attacks

func _ready():
	body = get_parent()
	while not body is Body:
		body = body.get_parent()
		if body == get_tree():
			break
	_initialize()
			
func _create_instance() -> Attack:
	return null

func _upgrade(_attack: String):
	_initialize()

func _initialize():
	pass
