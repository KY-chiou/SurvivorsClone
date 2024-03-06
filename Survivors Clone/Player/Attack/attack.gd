extends Area2D

class_name Attack

var level := 1
var hp: int
var speed: int
var damage: int
var knockback_amount: int
var attack_size: float

var lifetime := 10.0 # 10 s

@export var periodOfHitToTheSameEnemy := 2.0

func _ready():
	top_level = true	# 使之顯示與玩家完全分離
	area_entered.connect(Callable(self, "on_area_entered"))
	
func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0:
		on_lifetime_timeout()
	
# 碰撞後檢查是否穿透
func on_hit_enemy(charge := 1):
	hp -= charge
	if hp <= 0:
		queue_free()
		
# 一定時間後清除
func on_lifetime_timeout():
	queue_free()
	
func on_area_entered(_area):
	print("on_area_entered")
