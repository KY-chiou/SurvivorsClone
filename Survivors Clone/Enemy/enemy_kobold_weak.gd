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
	if hp <= 0:
		on_death()
	else:
		soundHit.play()
