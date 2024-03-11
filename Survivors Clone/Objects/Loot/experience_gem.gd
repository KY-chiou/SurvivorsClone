extends Loot

@export var experience = 5

const GEM_GREEN = preload("res://Textures/Items/Gems/Gem_green.png")
const GEM_BLUE = preload("res://Textures/Items/Gems/Gem_blue.png")
const GEM_RED = preload("res://Textures/Items/Gems/Gem_red.png")

@onready var audio_stream_player = $AudioStreamPlayer
@onready var collision_shape_2d = $CollisionShape2D


func _ready():
	_sprite_2d = $Sprite2D
	if experience < 5:
		_sprite_2d.texture = GEM_GREEN
	elif experience < 25:
		_sprite_2d.texture = GEM_BLUE
	else:
		_sprite_2d.texture = GEM_RED


func _onLooted():
	super._onLooted()
	collision_shape_2d.call_deferred("set", "disabled", true)
	audio_stream_player.play()
	

func _on_audio_stream_player_finished():
	queue_free()
