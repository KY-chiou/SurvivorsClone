extends SummonAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.level = level
	return attack
