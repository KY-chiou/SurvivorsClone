extends Body

# Attack
@onready var iceSpearAttack := %IceSpear
@onready var tornadoAttack := %Tornado

# Enemy
var closed_emenies: Array[Enemy] = []

# Animation
@onready var walkTimer = get_node("%walkTimer")

func _physics_process(_delta):
	super._physics_process(_delta)
	movement()
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	angle = Vector2(x_mov, y_mov)
	
	if angle.x != 0:
		sprite.flip_h = angle.x > 0
		
	if angle != Vector2.ZERO:
		# change animation frame every n second. where n is wait time in Timer.
		if walkTimer.is_stopped():
			#sprite.frame = 1 if sprite.frame == 0 else 0
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = angle.normalized() * movement_speed + knockback
	move_and_slide()	# already take account of delta

# 將 HurtBoxType 設為 DisableHitbox，使敵人攻擊後產生0.5秒的冷卻時間
func _on_hurt_box_hurt(damage, knock_angle, knock_amount):
	on_hurt(damage, knock_angle, knock_amount)
	print(hp)
		
func get_random_target() -> Vector2:
	if not closed_emenies.is_empty():
		return closed_emenies.pick_random().global_position
	else:
		return Vector2.UP
		
func get_nearest_target() -> Vector2:
	if not closed_emenies.is_empty():
		closed_emenies.sort_custom(sort_ascending)
		return closed_emenies.front().global_position
	else:
		return Vector2.UP
		
# 若結果為true，b則排到後面
func sort_ascending(a: Enemy, b: Enemy) -> bool:
	return a.distance_to_player() < b.distance_to_player()

# 偵測Body(ex: CharacterBody2D)進出，Collision Layer/ Mask也需在Body的屬性內設置，而非Area的屬性
func _on_enemy_detection_area_body_entered(body):
	if not closed_emenies.has(body):
		closed_emenies.append(body)

func _on_enemy_detection_area_body_exited(body):
	if closed_emenies.has(body):
		closed_emenies.erase(body)
