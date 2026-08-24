extends CanvasLayer

@export var arena_timer_manager : Node
@onready var label = %Label


# 获取经过时间并更新界面
func _process(delta):
	if arena_timer_manager == null:
		return
		
	var time_elasped = arena_timer_manager.get_time_elapsed()
	
	label.text = format_seconds_to_string(time_elasped)


# 将秒数转换成 “分钟 : 秒” 的格式
func format_seconds_to_string(seconds : float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
