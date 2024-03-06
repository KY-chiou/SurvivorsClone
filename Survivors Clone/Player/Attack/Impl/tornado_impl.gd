extends AttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = parent.position
	attack.last_movement = parent.last_non_zero_angle
	attack.level = level
	return attack
