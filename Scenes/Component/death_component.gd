extends Node2D

@export var health_component : Node
@export var sprite : Sprite2D


# 设置粒子图片并监听死亡事件
func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


# 死亡时播放消失动画
func on_died():
	if owner == null || !owner is Node2D:
		return 
	
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	
#	将死亡效果从原节点中移出并保留在场景中
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play("default")
