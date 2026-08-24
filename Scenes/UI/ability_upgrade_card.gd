extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label : Label = $%DescriptionLabel


# 监听卡片的输入事件
func _ready():
	gui_input.connect(on_gui_input)


# 显示升级的名称和说明
func set_ability_upgrade(upgrade : AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


# 点击卡片时发出选择信号
func on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
