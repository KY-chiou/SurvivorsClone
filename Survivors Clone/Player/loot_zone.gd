extends Node

# 吸經驗
@onready var detector = $Detector
@onready var detector_collision = $Detector/CollisionShape2D

# 消化經驗
@onready var digester = $Digester

var body: Body

signal on_looted_experience(experience: int)

func _ready():
	var _body = get_parent()
	while not _body is Body:
		_body = _body.get_parent()
		if _body == get_tree():
			break
	body = _body
	if body.get("loot_range"):
		(detector_collision.shape as CircleShape2D).radius = body.loot_range


func _physics_process(_delta):
	detector.global_position = body.global_position
	digester.global_position = body.global_position


func _on_detector_area_entered(area):
	if area is Loot:
		area._onDetected(detector)
		

func _on_digester_area_entered(area):
	if area is Loot:
		if area.get("experience"):
			on_looted_experience.emit(area.experience)
		area._onLooted()
