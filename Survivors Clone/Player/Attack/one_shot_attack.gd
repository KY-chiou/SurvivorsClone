extends Attack

class_name OneShotAttack

var lifetime := 10.0 # 10 s
	
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
