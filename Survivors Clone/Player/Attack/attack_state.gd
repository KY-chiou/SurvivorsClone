extends State

class_name AttackState

@export var attack: Attack

var angle := Vector2.ZERO

var target := Vector2.ZERO
var target_array = []

var _change_direction_time = 0

const sprite_normal = preload("res://Textures/Items/Weapons/javelin_3_new.png")
const sprite_attack = preload("res://Textures/Items/Weapons/javelin_3_new_attack.png")

func _enter():
	# 轉換攻擊材質 + 啟動碰撞
	%Sprite.texture = sprite_attack
	%CollisionShape.call_deferred("set", "disabled", false)
	
	# 生成路徑
	target_array.clear()
	for i in range(attack.paths):
		var new_path = body.get_random_target()
		if new_path:
			target_array.append(new_path)
	change_direction()
	
func _exit():
	# 轉換普通材質 + 關閉碰撞
	%Sprite.texture = sprite_normal
	%CollisionShape.call_deferred("set", "disabled", true)
	
func _update(delta: float):
	# 攻擊完成後換到下個路徑
	if _change_direction_time < attack.duration_once_attack:
		_change_direction_time += delta
	else:
		change_direction()
	
func _physics_update(delta: float):
	attack.position += angle * attack.speed * delta

func change_direction():
	# 完成所有路徑後回到IDLE
	if target_array.is_empty():
		transition_event.emit(self, "IdleState")
	else:
		# 每次出擊時發出音效
		%SoundPlayer.play()
		
		# 轉移目標路徑
		target = target_array[0]
		angle = attack.global_position.direction_to(target)
		target_array.remove_at(0)
		_change_direction_time = 0
		
		# 加入動畫較自然
		var new_rotation_angle = angle.angle() + deg_to_rad(135)
		var tween = create_tween()
		tween.tween_property(attack, "rotation", new_rotation_angle, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()
