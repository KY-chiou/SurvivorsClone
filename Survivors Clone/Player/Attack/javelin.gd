extends SummonAttack

# Visibility > Top level 設置為 true，使之顯示與玩家完全分離

@export var duration_once_attack := 3.0

var paths := 1

var angle := Vector2.ZERO
var reset_pos := Vector2.ZERO

@onready var impl_parent = get_impl_parent()

func _ready():
	super._ready()
	update()
	
func update():
	level = impl_parent.level
	match level:
		1:
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * attack_size_ratio
			cd = 5.0 * cd_ratio
			paths = 1
		2:
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * attack_size_ratio
			cd = 5.0 * cd_ratio
			paths = 2
		3:
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * attack_size_ratio
			cd = 5.0 * cd_ratio
			paths = 3
		4:
			speed = 200
			damage = 15
			knockback_amount = 120
			attack_size = 1.0 * attack_size_ratio
			cd = 5.0 * cd_ratio
			paths = 3
	
	scale = Vector2.ONE * attack_size
