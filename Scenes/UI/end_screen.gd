extends CanvasLayer

@onready var panel_container = $%PanelContainer


# 暂停游戏并连接按钮事件
func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween = create_tween()
	
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)


# 设置失败界面的文字
func set_defeat():
	$%TitleLabel.text = "LOST"
	$%DescriptionLabel.text = "You were defeated. Better luck next time!"
	play_jingle(true)


func play_jingle(defeat : bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


# 重新开始游戏
func on_continue_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/meta_menu.tscn")


# 退出游戏
func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://Scenes/UI/main_menu.tscn")
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
