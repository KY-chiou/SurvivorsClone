extends SummonAttackImpl

func _create_instance() -> Attack:
	var attack = attackResource.instantiate()
	attack.position = body.position
	attack.level = level
	return attack

func _upgrade(attack: String):
	match attack:
		"javelin1":
			level = 1
			ammo += 1
		"javelin2":
			level = 2
		"javelin3":
			level = 3
		"javelin4":
			level = 4
	super._upgrade(attack)
