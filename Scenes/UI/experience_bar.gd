extends CanvasLayer

@export var experience_manager : Node

@onready var progress_bar = $MarginContainer/ProgressBar


# 初始化经验条并监听经验变化
func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)


# 根据当前经验更新经验条
func on_experience_updated(current_experience : float, target_experience : float):
	var percent = current_experience / target_experience
	
	progress_bar.value = percent
