extends Panel

const MAX_OPTIONS = 3

const ITEM_OPTION = preload("res://Utility/item_option.tscn")

func on_level_up():
	get_tree().paused = true
	
	visible = true
	
	# 初始化選項
	for i in range(MAX_OPTIONS):
		var option = ITEM_OPTION.instantiate() as ItemOption
		option.on_selected_upgraded.connect(on_item_selected)
		%UpgradeOptions.add_child(option)
	
	# 升級效果音
	%LevelUpSound.play()
		
	# 暫停遊戲 & 升級面板
	# 避免暫停升級面板，升級面板的屬性 > Process > Mode需設置回When Paused
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(220, 50), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func on_item_selected(itemOption: ItemOption):
	print("on_item_selected: ", itemOption)
	
	visible = false
	position = Vector2(800, 50)
	
	for io in %UpgradeOptions.get_children():
		#%UpgradeOptions.remove_child(io)
		io.queue_free() # 同時也會從 parent 中移除
	
	get_tree().paused = false
