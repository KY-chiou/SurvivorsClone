extends AttackImpl

class_name OneShotAttackImpl

@onready var timer := Timer.new()
@onready var attackTimer = Timer.new()

@export var charge_once := 1

@export var cd := 3.0
@export var period_once_attack := 1.0

func _ready():
	super._ready()

	#print(attackResource)
	#print(self)
	#print("%d, %d, %d" % [charge_once, ammo, level])
	#print("%s, %s" % [str(cd), str(period_once_attack)])
	
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
		body.call_deferred("add_child", attack)
		ammo -= 1
		# 若還有子彈，則再次擊發
		if ammo > 0:
			attackTimer.start()
		else:
			attackTimer.stop()
