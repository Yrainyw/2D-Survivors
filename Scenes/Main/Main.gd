extends Node

@export var end_screen_scene : PackedScene


# 监听玩家死亡信号
func _ready():
	$%Player.health_component.died.connect(on_player_died)


# 玩家死亡后显示失败界面
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()

