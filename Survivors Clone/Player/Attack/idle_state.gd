extends State

class_name IdleState

@export var attack: Attack

var _elapsed_time := 0.0

var _return_time := 0.0
var _return_pos := Vector2.ZERO

# CD 重新冷卻
func reset():
	_elapsed_time = 0
	randomize_return()

# 重置回來路徑
func randomize_return():
	_return_pos = body.global_position + Vector2(randf(), randf()).normalized() * 100
	_return_time = randf_range(1, 3)

func _enter():
	reset()
	%CollisionShape.call_deferred("set", "disabled", true)
	
func _exit():
	pass
	
func _update(delta: float):
	# 每隔一定時間隨機變化回來路徑
	if _return_time > 0:
		_return_time -= delta
	else:
		randomize_return()
	
	# CD 好了轉攻擊模式
	if _elapsed_time < attack.cd:
		_elapsed_time += delta
	else:
		transition_event.emit(self, "AttackState")
	
func _physics_update(delta: float):
	var return_angle = attack.global_position.direction_to(_return_pos)
	var return_dis = attack.global_position.distance_squared_to(_return_pos)
	var return_speed = 50 + 100 * clamp(return_dis / 500, 0.0, 1.0)
	attack.position += return_angle * return_speed * delta

	# 調整角度
	#attack.rotation = return_angle.angle() + deg_to_rad(135)
	attack.rotation = attack.global_position.direction_to(body.global_position).angle() + deg_to_rad(135)
