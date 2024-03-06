extends CharacterBody2D

class_name Body

# Property
@export var movement_speed: float
@export var hp: int
var angle := Vector2.ZERO :
	set(value):
		angle = value
		if value != Vector2.ZERO:
			_last_non_zero_angle = value
var _last_non_zero_angle := Vector2.UP
var last_non_zero_angle:
	get:
		return _last_non_zero_angle

# Body
@onready var sprite = $Sprite2D

# Knockback
@export var knockback_amount := 0.0
@export var knockback_recovery := 5.0
var knockback := Vector2.ZERO

func _physics_process(_delta):
	# 使擊退隨著幀數遞減到 0(Vector2.ZERO)
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)

func on_hurt(damage, knock_angle, knock_amount):
	hp -= damage
	knockback += knock_angle * knock_amount
	#print("knockback: %s" % str(knockback))
