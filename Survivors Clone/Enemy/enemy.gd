extends Body

class_name Enemy

# Animation
@onready var anim = $AnimationPlayer
const death_anim = preload("res://Enemy/explosion.tscn")

# Audio
const soundHitResource = preload("res://Audio/SoundEffect/enemy_hit.ogg")
@onready var soundHit = create_sound(soundHitResource)

# 呼喚場景樹(世界樹)取得player資訊
@onready var player = get_tree().get_first_node_in_group("player")

func distance_to_player() -> float:
	return position.distance_squared_to(player.position)

func create_sound(stream: Resource, volume := -20.0) -> AudioStreamPlayer2D:
	var audio = AudioStreamPlayer2D.new()
	audio.stream = stream
	audio.volume_db = volume
	# 聲音節點需要加入，否則無法作用
	add_child(audio)
	return audio
	
# 死亡時生成爆炸動畫，不能加(add_child)在此物件裡，否則回隨著物件刪除而消失
func on_death():
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	# 加在親物件裡
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()
