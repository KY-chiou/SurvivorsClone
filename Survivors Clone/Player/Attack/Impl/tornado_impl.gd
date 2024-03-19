extends OneShotAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.last_movement = body.last_non_zero_angle
	attack.level = level
	return attack

func _upgrade(attack: String):
	match attack:
		"tornado1":
			level = 1
			charge_once += 1
		"tornado2":
			level = 2
			charge_once += 1
		"tornado3":
			level = 3
			cd -= 0.5
		"tornado4":
			level = 4
			charge_once += 1
	super._upgrade(attack)
