extends ColorRect

class_name ItemOption

var mouse_over := false

@onready var player := Player.get_first(self)

var item: String
var info: Dictionary

signal on_selected_upgraded(itemOption: ItemOption)

func _ready():
	if not item:
		item = "food"
	info = UpgradeDb.UPGRADES[item]
	%Name.text = info["displayname"]
	%Description.text = info["details"]
	%Level.text = info["level"]
	%Icon.texture = load(info["icon"])

func _input(event):
	if mouse_over and event is InputEventMouseButton and event.is_released():
		on_clicked()
			
func on_clicked():
	on_selected_upgraded.emit(self)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
