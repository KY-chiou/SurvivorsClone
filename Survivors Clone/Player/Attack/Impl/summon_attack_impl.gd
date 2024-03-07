extends AttackImpl

class_name SummonAttackImpl

var _summoned: Array[Attack] = []

func _ready():
	super._ready()
	
	# 持有等級大於0
	if level > 0:
		while ammo > _summoned.size():
			var attck = _create_instance()
			add_child(attck)
			_summoned.append(attck)
