extends Panel

const MAX_OPTIONS = 3

const ITEM_OPTION = preload("res://Utility/item_option.tscn")

# 選過的
var collected_upgrades: Array[String] = []
# 候選名單
var upgrade_options: Array[String] = []

signal on_upgraded(upgrade: String)

func on_level_up():
	get_tree().paused = true
	
	visible = true
	
	# 初始化選項
	update_options()
	for i in pick_random_options():
		var option = ITEM_OPTION.instantiate() as ItemOption
		option.item = i
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
	print("on_item_selected: ", itemOption.info)
	
	collected_upgrades.append(itemOption.item)
	upgrade_options.erase(itemOption.item)
	
	visible = false
	position = Vector2(800, 50)
	
	for io in %UpgradeOptions.get_children():
		#%UpgradeOptions.remove_child(io)
		io.queue_free() # 同時也會從 parent 中移除
	
	get_tree().paused = false
	
	on_upgraded.emit(itemOption.item)

func update_options():
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif not UpgradeDb.UPGRADES[i]["prerequisite"].is_empty():
			var doAdd = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				#print("update_options. %s: %s" % [i, str(n)])
				if n not in collected_upgrades:
					doAdd = false
					break
			if doAdd:
				upgrade_options.append(i)
		else:
			upgrade_options.append(i)
	#print("upgrade_options: ", upgrade_options)
				
func pick_random_options(number: int = MAX_OPTIONS) -> Array[String]:
	var copy = upgrade_options.duplicate()
	copy.shuffle()
	copy.resize(number)
	#print("pick_random_options: ", copy)
	return copy
