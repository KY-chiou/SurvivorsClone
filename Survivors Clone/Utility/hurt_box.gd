extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimber = $DisableTimer

var onHitAttacks: Array[Attack] = []

signal hurt(damage, knock_angle, knockback_amount)

# 當其他area(ex: HitBox)進入此area(HurtBox)時
# 與其他area相撞(collide)時，此方法才會被呼叫，因此Collision Mask要設定
func _on_area_entered(area):
	if area.is_in_group("attack"):
		if area.get("damage") != null:	# 檢查是否具有屬性"damage"
			match HurtBoxType:
				0:	# Cooldown -> DisableHurtBox
					if onHitAttacks.has(area):
						return
					else:
						on_hit_by_attack(area)
						# collision.disabled = true	# 直接禁用可能有BUG
						collision.call_deferred("set", "disabled", true)	# 當collision空閒時讓他禁用
						disableTimber.start()
				1:	# HitOnce 覺得原CODE不好，不用
					pass
				2:	# DisableHitBox
					if area.has_method("on_hit_hurt_box"):
						area.on_hit_hurt_box()
			
			# 傷害 & 擊退
			var damage = area.damage
			var knock_angle = Vector2.ZERO if area.get("angle") == null else area.angle
			var knockback_amount = 1 if area.get("knockback_amount") == null else area.knockback_amount
			
			#if get_parent().has_method("hurt"):
				#get_parent().hurt(damage)
			# 不推薦直接呼叫parent的方法，否則難以維護，Godot社群有一句話
			# Signal Up. Call Down.
			# 用 Signal 傳遞訊息給parent
			# 從 parent 直接呼叫child的方法
			emit_signal("hurt", damage, knock_angle, knockback_amount)
			if area is Attack:
				area.on_hit_enemy()
			

# 傷害禁用的冷卻時間到了，重新啟用傷害
func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)

# 避免短時間對同一敵人造成傷害
func on_hit_by_attack(attack: Attack):
	if not attack is Attack:
		return
	onHitAttacks.append(attack)
	var timer = Timer.new()
	timer.wait_time = attack.periodOfHitToTheSameEnemy
	timer.timeout.connect(
		func():
			onHitAttacks.erase(attack)
			timer.queue_free()
	)
	add_child(timer)
	timer.start()
