extends Area2D

class_name Attack

var level := 1
var hp: int
var speed: int
var damage: int
var knockback_amount: int
var attack_size: float

var body: Node

@export var periodOfHitToTheSameEnemy := 2.0

var attack_size_ratio: float:
	get:
		return 1.0 if not body is Player else 1.0 + (body as Player).spell_size

func _ready():
	body = get_parent()
	while not body is Body:
		body = body.get_parent()
		if body == get_tree():
			break
			
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
