extends Button

signal selected(upgrade: Upgrade)
signal hovered(upgrade: Upgrade)

@onready var upgrade_icon: TextureRect = $Icon
var upgrade: Upgrade


func _ready() -> void:
	upgrade_icon.texture = upgrade.base_img
	pressed.connect(func(): selected.emit(upgrade))


func _on_mouse_entered() -> void:
	upgrade_icon.texture = upgrade.hover_img
	hovered.emit(upgrade)


func _on_mouse_exited() -> void:
	if not has_focus():
		upgrade_icon.texture = upgrade.base_img
