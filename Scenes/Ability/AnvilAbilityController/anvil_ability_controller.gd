extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

@export var anvil_ability_scene : PackedScene


func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
	
	var target_enemy = get_nearest_enemy(player.global_position)
	
	if target_enemy == null:
		return
	
	var spawn_position = target_enemy.global_position
	var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability = anvil_ability_scene.instantiate()
	
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
	anvil_ability.hitbox_component.damage = BASE_DAMAGE


# 找出离指定位置最近的敌人
func get_nearest_enemy(from_position : Vector2) -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.is_empty():
		return null
	
	var nearest = enemies[0]
	var nearest_distance = from_position.distance_squared_to(nearest.global_position)
	
	for enemy in enemies:
		var distance = from_position.distance_squared_to(enemy.global_position)
		
		if distance < nearest_distance:
			nearest = enemy
			nearest_distance = distance
	
	return nearest
