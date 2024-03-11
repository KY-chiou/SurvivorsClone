extends Body

@export var loot_range := 50.0
@export var experience_ratio := 1.0

@export var experience := 0
var experience_level := 1

var total_collected_experience := 0

# Enemy
var closed_emenies: Array[Enemy] = []

# Animation
@onready var walkTimer = get_node("%walkTimer")

func _ready():
	calculate_experience()

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

func _on_loot_zone_on_looted_experience(gem_exp):
	experience += gem_exp
	total_collected_experience += gem_exp
	calculate_experience()

func calculate_experience():
	var exp_required = calculate_required_experience()
	while experience >= exp_required:
		experience -= exp_required
		level_up()
		exp_required = calculate_required_experience()
	(%ExperienceBar as TextureProgressBar).value = experience * 100.0 / exp_required
		
func level_up():
	experience_level += 1
	(%LevelLabel as Label).text = "Level: %d" % experience_level
	var se = $LevelUpSound as AudioStreamPlayer
	if not se.playing:
		se.play()

func calculate_required_experience() -> int:
	var exp_cap: int
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience < 40:
		exp_cap = 100 + (experience_level - 19) * 8
	else:
		exp_cap = 260 + (experience_level - 39) * 12
	return exp_cap
