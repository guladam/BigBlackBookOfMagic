extends Panel


var upgrade: Upgrade


func _ready() -> void:
	if upgrade:
		$TextureRect.texture = upgrade.hover_img
		$Label.text = upgrade.upgrade_name
