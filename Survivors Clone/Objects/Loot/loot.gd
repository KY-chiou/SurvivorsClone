extends Area2D

class_name Loot

var _target_area: Area2D

# 往回彈一下再被吸去
var _speed := -3.5

var _sprite_2d: Sprite2D

func _physics_process(_delta):
	if _target_area:
		global_position = global_position.move_toward(_target_area.global_position, _speed)

func _onDetected(area: Area2D):
	_target_area = area
	var tween = create_tween()
	tween.tween_property(self, "_speed", 50.0, 10.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func _onLooted():
	if _sprite_2d:
		_sprite_2d.visible = false
