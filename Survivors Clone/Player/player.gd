extends Body

class_name Player

static func get_first(node: Node) -> Player:
	return node.get_tree().get_first_node_in_group("player")

@export var loot_range := 50.0
@export var experience_ratio := 1.0

@export var experience := 0
var experience_level := 1

var total_collected_experience := 0

# Enemy
var closed_emenies: Array[Enemy] = []

# Animation
@onready var walkTimer = get_node("%walkTimer")

# GUI
@onready var level_up_panel = %LevelUp

# Attack
@onready var ice_spear: OneShotAttackImpl = %IceSpear
@onready var tornado: OneShotAttackImpl = %Tornado
@onready var javelin: SummonAttackImpl = %Javelin

# Upgrade
@export var maxhp: int

var armor := 0
var additional_attacks := 0
var speed := 0.0
var spell_cooldown := 0.0
var spell_size := 0.0

func _ready():
	maxhp = hp
	level_up_panel.on_upgraded.connect(on_upgraded)
	await get_tree().create_timer(1).timeout
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
	var new_damage = clamp(damage - armor, 1, 999)
	on_hurt(new_damage, knock_angle, knock_amount)
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

# 加總經驗並判斷是否升級
func calculate_experience():
	var exp_required = calculate_required_experience()
	if experience >= exp_required:
		experience -= exp_required
		level_up()
	(%ExperienceBar as TextureProgressBar).value = experience * 100.0 / exp_required
		
func level_up():
	# 更新Label
	experience_level += 1
	(%LevelLabel as Label).text = "Level: %d" % experience_level
	
	# 通知面板
	level_up_panel.on_level_up()

		
# 計算所需經驗
func calculate_required_experience() -> int:
	var exp_cap: int
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience < 40:
		exp_cap = 100 + (experience_level - 19) * 8
	else:
		exp_cap = 260 + (experience_level - 39) * 12
	return exp_cap

# https://pastebin.com/kC9ab42b
func on_upgraded(upgrade: String):
	match upgrade:
		"icespear1", "icespear2", "icespear3", "icespear4":
			ice_spear._upgrade(upgrade)
		"tornado1", "tornado2", "tornado3", "tornado4":
			tornado._upgrade(upgrade)
		"javelin1", "javelin2", "javelin3", "javelin4":
			javelin._upgrade(upgrade)
		"armor1", "armor2", "armor3", "armor4":
			armor += 1
		"speed1", "speed2", "speed3", "speed4":
			movement_speed += 20.0
		"tome1", "tome2", "tome3", "tome4":
			spell_size += 0.10
		"scroll1", "scroll2", "scroll3", "scroll4":
			spell_cooldown += 0.05
		"ring1", "ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp, 0, maxhp)
	calculate_experience()
	
