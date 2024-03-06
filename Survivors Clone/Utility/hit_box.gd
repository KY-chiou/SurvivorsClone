extends Area2D

# Collision
#	Layer: 此Area所存在的層
#	Mask: 此Area的碰撞對象所在的層
# HitBox只需等著被HurtBox撞，因此Collision Mask不需要設置，但Collision Layer必須設置

var damage := 1
@onready var collision = $CollisionShape2D
@onready var disableTimber = $DisableHitBoxTimer

@onready var parent = get_parent()

var knockback_amount: float:
	get:
		return 0 if parent.get("knockback_amount") == null else parent.knockback_amount
		
var angle: Vector2:
	get:
		return 0 if parent.get("angle") == null else parent.angle

func on_hit_hurt_box():
	collision.call_deferred("set", "disabled", true)
	disableTimber.start()

func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false)
