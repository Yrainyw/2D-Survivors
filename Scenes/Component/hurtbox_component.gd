extends Area2D

class_name HurtboxComponent

signal hit

@export var health_component : Node

var floating_text_scene = preload("res://Scenes/UI/floating_text.tscn")


# 监听其他攻击区域进入
func _ready():
	area_entered.connect(on_area_entered)


# 受到攻击时扣除生命值并显示伤害数字
func on_area_entered(other_area : Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	
	health_component.damage(hitbox_component.damage)
	
#	创建飘动的伤害数字
	var floating_text = floating_text_scene.instantiate() as Node2D
	
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	
	var format_string = "%0.1f"
	
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f"
	
	floating_text.start(format_string % hitbox_component.damage)
	hit.emit()
