extends OneShotAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.target = body.get_nearest_target()
	attack.level = level
	return attack

func _upgrade(attack: String):
	match attack:
		"icespear1":
			level = 1
			charge_once += 1
		"icespear2":
			level = 2
			charge_once += 1
		"icespear3":
			level = 3
		"icespear4":
			level = 4
			charge_once += 2
	super._upgrade(attack)
