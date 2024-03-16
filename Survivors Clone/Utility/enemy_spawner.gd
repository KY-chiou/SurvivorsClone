extends Node2D


@export var spawns: Array[SpawnInfo] = []

@onready var player = Player.get_first(self)

var time = 0

# 倒數 Wait Time 秒後呼叫 timeout()
# One Shot = false時，每當倒數結束後重新倒數
# Autostart 當Timer生成時自動開始倒數
func _on_timer_timeout():
	time += 1	# 每次倒數結束後，計數一次
	var enemy_spawns = spawns
	# 所有敵人的生成延遲計數+1
	for info in enemy_spawns:
		if time >= info.time_start and time <= info.time_end:
			if info.spawn_delay_counter < info.enemy_spawn_delay:
				info.spawn_delay_counter += 1
			else:
				info.spawn_delay_counter = 0
				# 載入敵人Resource
				# 載入參數為string，從敵人的Resource路徑(ex: enemy_kobold_weak.tscn)讀取Resource
				# 當設置於SpawnInfo時就已經Load了
				# var new_enemy = load(str(info.enemy.resource_path))
				var new_enemy = info.enemy
				for count in range(info.enemy_num):
					var enemy_spawn = new_enemy.instantiate()
					# 分配隨機位置後，加入enemy_spawn子節點到此(EnemySpawner)節點裡
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)

# 比視窗稍大的方框邊緣的某處
func get_random_position() -> Vector2:
	# 範圍
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	
	# 此刻的玩家位置
	var pp = player.global_position
	# 生成點
	var rp = Vector2.ZERO
	
	var random_x = randf_range(-vpr.x / 2, vpr.x / 2) + pp.x
	var random_y = randf_range(-vpr.y / 2, vpr.y / 2) + pp.y

	# 隨機選擇四邊中的某一邊
	match randi_range(0, 3):
		0:	# up
			rp = Vector2(random_x, pp.y - vpr.y / 2)
		1:	# down
			rp = Vector2(random_x, pp.y + vpr.y / 2)
		2:	# left
			rp = Vector2(pp.x - vpr.x / 2, random_y)
		3:	# right
			rp = Vector2(pp.x + vpr.x / 2, random_y)
	# print("spawn position: %s, player position: %s" % [str(rp), str(pp)])
	return rp

	
