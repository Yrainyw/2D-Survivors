extends CanvasLayer


# 暂停游戏并连接按钮事件
func _ready():
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)


# 设置失败界面的文字
func set_defeat():
	$%TitleLabel.text = "LOST"
	$%DescriptionLabel.text = "You were defeated. Better luck next time!"


# 重新开始游戏
func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main/Main.tscn")


# 退出游戏
func on_quit_button_pressed():
	get_tree().quit()
