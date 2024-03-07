extends OneShotAttack

const loop_tween_duration := 1.0

var last_movement := Vector2.ZERO

var angle := Vector2.ZERO
var angle_less := Vector2.ZERO
var angle_more := Vector2.ZERO
var angle_toward := Vector2.ZERO

var tween_counter := 0

func _ready():
	super._ready()
	hp = 10000
	lifetime = 20.0
	match level:
		1:
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
			
	# 生成左右偏移角度
	var move_to_less := Vector2.ZERO
	var move_to_more := Vector2.ZERO
	var randf_less = randf_range(-1, -0.25)
	var randf_more = randf_range(0.25, 1)
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = Vector2(randf_less, last_movement.y)
			move_to_more = Vector2(randf_more, last_movement.y)
		Vector2.LEFT, Vector2.RIGHT:
			move_to_less = Vector2(last_movement.x, randf_less)
			move_to_more = Vector2(last_movement.x, randf_more)
		Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1):
			move_to_less = Vector2(last_movement.x, last_movement.y + randf_range(0, 0.75))
			move_to_more = Vector2(last_movement.x + randf_range(0, 0.75), last_movement.y)
			
	angle_less = move_to_less.normalized()
	angle_more = move_to_more.normalized()
	# 隨機先從左或右開始
	angle_toward = angle_less if randi_range(0, 1) == 0 else angle_more
	
	# 僅執行一次的動畫，改變大小與速度
	var tween = create_tween().set_parallel(true)
	var final_speed = speed
	speed /= 5
	tween.tween_property(self, "scale", Vector2.ONE * attack_size, 3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "speed", final_speed, 6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	# 執行重複動畫
	#play_tween()
	play_loop_tween()

func _physics_process(delta):
	super._physics_process(delta)
	position += angle * speed * delta

# 執行完後呼叫callback
func play_tween():
	tween_counter += 1
	var tween = create_tween()
	tween.tween_property(self, "angle", angle_toward, loop_tween_duration)
	tween.tween_callback(Callable(self, "on_tween_finished"))
	tween.play()

# 改變角度後再次執行
func on_tween_finished():
	print("on_tween_finished. done: %d times" % tween_counter)
	angle_toward = angle_less if angle_toward == angle_more else angle_more
	play_tween()
	
# 利用 set_loops 重複執行, set_loops無參數時會無限重複
func play_loop_tween():
	var tween = create_tween()
	var angle_first = angle_toward
	var angle_second = angle_less if angle_first == angle_more else angle_more
	tween.tween_property(self, "angle", angle_first, loop_tween_duration)
	tween.tween_property(self, "angle", angle_second, loop_tween_duration)
	tween.set_loops(ceil(lifetime / loop_tween_duration))
	tween.play()
	
func on_hit_enemy(_charge := 1):
	pass
