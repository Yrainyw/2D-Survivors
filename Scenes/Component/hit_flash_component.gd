extends Node

@export var health_component : Node
@export var sprite : Sprite2D
@export var hit_flash_material : ShaderMaterial

var hit_flash_tween : Tween


# 监听生命值变化并设置闪烁材质
func _ready():
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material


# 受到伤害时播放闪白效果
func on_health_changed():
#	停止上一次还未结束的动画
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
#	让闪白效果逐渐恢复
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
