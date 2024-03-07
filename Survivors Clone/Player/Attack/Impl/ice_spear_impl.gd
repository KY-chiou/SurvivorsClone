extends OneShotAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.target = body.get_nearest_target()
	attack.level = level
	return attack
