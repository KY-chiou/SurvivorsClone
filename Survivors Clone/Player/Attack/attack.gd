extends Area2D

class_name Attack

var level := 1
var hp: int
var speed: int
var damage: int
var knockback_amount: int
var attack_size: float

@export var periodOfHitToTheSameEnemy := 2.0

func _ready():
	top_level = true	# 使之顯示與玩家完全分離
	#area_entered.connect(Callable(self, "on_area_entered"))
	
func _physics_process(_delta):
	pass
	
# 碰撞後檢查是否穿透
func on_hit_enemy(_charge := 1):
	pass
	
#func on_area_entered(_area):
	#print("on_area_entered")
	
func get_impl_parent() -> AttackImpl:
	var parent = get_parent()
	while not parent is AttackImpl:
		parent = parent.get_parent()
		if parent == get_tree():
			parent = null
			break
	return parent
