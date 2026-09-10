extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

@export var anvil_ability_scene : PackedScene

var anvil_count = 0


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
	
	var target_enemies = get_nearest_enemies(player.global_position, anvil_count + 1)
	
	for target_enemy in target_enemies:
		spawn_anvil(player.global_position, target_enemy.global_position)


func spawn_anvil(player_position : Vector2, target_position : Vector2):
	var spawn_position = target_position
	var query_paramaters = PhysicsRayQueryParameters2D.create(player_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability = anvil_ability_scene.instantiate()
	
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
	anvil_ability.hitbox_component.damage = BASE_DAMAGE


# 找出离指定位置最近的多个敌人，按距离从近到远排序，返回最多 count 个
func get_nearest_enemies(from_position : Vector2, count : int) -> Array:
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.is_empty():
		return []
	
	enemies.sort_custom(func(a, b):
		var distance_a = from_position.distance_squared_to(a.global_position)
		var distance_b = from_position.distance_squared_to(b.global_position)
		return distance_a < distance_b
	)
	
	return enemies.slice(0, min(count, enemies.size()))


func on_ability_upgrade_added(upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrades["anvil_count"]["quantity"]
