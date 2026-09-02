extends Node

@export var end_screen_scene : PackedScene

var pause_menu_scene = preload("res://Scenes/UI/pause_menu.tscn")


# 监听玩家死亡信号
func _ready():
	$%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


# 玩家死亡后显示失败界面
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	
