extends Enemy

func _ready():
	anim.play("walk")

func _physics_process(_delta):
	super._physics_process(_delta)
	angle = global_position.direction_to(player.global_position)	# alreay applied normalized()
	velocity = angle * movement_speed + knockback
	move_and_slide()
	
	if angle.x > 0.1:
		sprite.flip_h = true
	elif angle.x < -0.1:
		sprite.flip_h = false

# 將 HurtBoxType 設為 Cooldown，使敵人被攻擊後有0.5秒的無敵時間
func _on_hurt_box_hurt(damage, knock_angle, knock_amount):
	on_hurt(damage, knock_angle, knock_amount)
	flash()
	if hp <= 0:
		on_death()
	else:
		soundHit.play()

# 受傷時閃白
func flash():
	var tween = create_tween()
	tween.tween_method(set_flash_progress, 0.0, 1.0, 0.1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_flash_progress, 1.0, 0.0, 0.05).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
		
# Sprite2D > Material > ShaderMaterial中設定
# 務必勾選Local to Scene使Material在單例中為唯一，否則Shader會同時作用到所有單例中
func set_flash_progress(progress: float):
	sprite.material.set_shader_parameter("progress", progress)
