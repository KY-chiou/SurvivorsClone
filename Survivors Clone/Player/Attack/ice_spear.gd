extends OneShotAttack

# Visibility > Top level 設置為 true，使之顯示與玩家完全分離

var target := Vector2.ZERO
var angle := Vector2.ZERO

func _ready():
	super._ready()
	angle = global_position.direction_to(target)	# alreay applied normalized()
	rotation = angle.angle() + deg_to_rad(135)	 # unit: rad
	match level:
		1, 2:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * attack_size_ratio
		3, 4:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * attack_size_ratio
			
	# Tween: 改變節點屬性的Animation
	var tween = create_tween()
	# 同時進行動畫
	tween.set_parallel(true)
	# 將原尺寸放大至設定的尺寸
	tween.tween_property(self, "scale", Vector2.ONE * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	# 設定平行後又想接續上的動畫時，使用chain()
	#tween.chain().tween_property(self, "modulate", Color(1, 0, 0, 1), 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	# 結束後呼叫綁定的方法
	#tween.tween_callback(Callable(self, "on_tween_finished"))
	tween.play()

func _physics_process(delta):
	super._physics_process(delta)
	position += angle * speed * delta
	
func on_tween_finished():
	#print("on_tween_finished")
	pass
