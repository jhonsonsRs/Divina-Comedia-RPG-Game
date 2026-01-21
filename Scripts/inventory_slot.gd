extends TextureButton
class_name InventorySlot

var icon: TextureRect
var item: ItemData = null

func _ready():
	icon = $Icon

func set_item(new_item: ItemData):
	item = new_item
	
	if icon == null:
		return
	
	if item != null and item.icon != null:
		icon.texture = item.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false
