extends Node

@export var experience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

# 提前加载升级资源
var upgrade_axe = preload("res://Resources/Upgrades/axe.tres")
var upgrade_axe_damage = preload("res://Resources/Upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://Resources/Upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://Resources/Upgrades/sword_damage.tres")


func _ready():
#	将初始升级加入升级池，数字 10 是抽到这个升级的权重
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	
	experience_manager.level_up.connect(on_level_up)


# 应用玩家选择的升级
func apply_upgrade(upgrade : AbilityUpgrade):
#	检查玩家之前是否获得过这个升级
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource" : upgrade,
			"quantity" : 1
		}
	else: 
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


# 根据玩家获得的技能，解锁新的升级选项
func update_upgrade_pool(chosen_upgrade : AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)


# 从升级池中随机选择两个不同的升级
func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []
	
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades


func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)


# 玩家等级提升时打开升级选择界面
func on_level_up(current_level : int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
