extends Sprite2D

# 聲音和動畫都設了自動播放
# 避免被攻擊物件覆蓋，可從屬性 > Ordering > Z index調整到比較高的位置

func _on_animation_explosion_animation_finished(_anim_name):
	queue_free()
