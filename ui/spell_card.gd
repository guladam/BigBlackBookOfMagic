extends ColorRect


var upgrade: Upgrade


func _ready() -> void:
	$TextureRect.texture = upgrade.hover_img
	$Label.text = upgrade.upgrade_name
