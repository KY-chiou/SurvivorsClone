extends OneShotAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.last_movement = body.last_non_zero_angle
	attack.level = level
	return attack
