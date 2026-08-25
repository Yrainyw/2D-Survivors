extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals

var number_colliding_bodies = 0
var base_speed = 0


# 连接玩家需要使用的信号
func _ready():
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


# 根据玩家输入移动并播放动画
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
#	根据移动方向翻转角色
	var move_sign = sign(movement_vector.x)
	
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


# 获取玩家的移动输入
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


# 接触敌人时按固定间隔受到伤害
func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()


# 更新生命条
func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body : Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body : Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	update_health_display()


# 获得新能力时添加对应的能力控制器
func on_ability_upgrade_added(abiliy_upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if abiliy_upgrade is Ability:
		abilities.add_child(abiliy_upgrade.ability_controller_scene.instantiate())
	elif abiliy_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)
