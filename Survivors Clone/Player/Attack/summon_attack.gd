extends Attack

class_name SummonAttack

var cd := 5.0

var cd_ratio: float:
	get:
		return 1.0 if not body is Player else 1.0 - (body as Player).spell_cooldown

func _ready():
	hp = 100000
