extends Resource

class_name SpawnInfo # Let this script can be referenced as a class

# 遊戲開始後，何時開始or結束生成
@export var time_start: int
@export var time_end: int

# 敵人種類
@export var enemy: Resource

# 同時生成的敵人數量
@export var enemy_num: int

# 生成延遲：spawn_delay_counter的值達到enemy_spawn_delay時生成
@export var enemy_spawn_delay: int
var spawn_delay_counter = 0
