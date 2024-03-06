extends Node

class_name AttackImpl

@onready var timer := Timer.new()
@onready var attackTimer = Timer.new()

@export var attackResource: Resource
@export var charge_once := 1
@export var ammo := 0
@export var level := 1

@export var cd := 3.0
@export var period_once_attack := 1.0

var parent: Node

func _ready():
	#print(attackResource)
	#print("%d, %d, %d" % [charge_once, ammo, level])
	#print("%s, %s" % [str(cd), str(period_once_attack)])
	
	parent = get_parent()
	while not parent is Body:
		parent = parent.get_parent()
		if parent == get_tree():
			break
	
	# 重設 Wait Time
	timer.wait_time = cd
	timer.timeout.connect(Callable(self, "on_timer_timeout"))
	attackTimer.wait_time = period_once_attack
	attackTimer.timeout.connect(Callable(self, "on_attack_timer_timeout"))
	add_child(timer)
	add_child(attackTimer)
	
	# 持有等級大於0
	if level > 0:
		if timer.is_stopped():
			timer.start()

# 填充彈藥
func on_timer_timeout():
	ammo += charge_once
	attackTimer.start()

# 若有子彈則發射
func on_attack_timer_timeout():
	if ammo > 0:
		var attack = _create_instance()
		parent.add_child(attack)
		ammo -= 1
		# 若還有子彈，則再次擊發
		if ammo > 0:
			attackTimer.start()
		else:
			attackTimer.stop()
			
func _create_instance() -> Attack:
	return null
