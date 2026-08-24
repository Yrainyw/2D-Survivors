extends Node2D


func _ready():
	pass


# 显示文字并播放飘动动画
func start(text : String):
	$Label.text = text
	
	var tween = create_tween()
	
#	允许位置和缩放动画同时播放
	tween.set_parallel()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
#	动画结束后删除文字
	tween.tween_callback(queue_free)
	
#	播放文字放大后缩小的效果
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
