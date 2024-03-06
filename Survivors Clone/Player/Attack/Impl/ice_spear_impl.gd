extends AttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = parent.position
	attack.target = parent.get_nearest_target()
	attack.level = level
	return attack
