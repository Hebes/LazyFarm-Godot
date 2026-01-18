class_name HoldItem

extends InventoryNode

var hold: Hold

## 测试代码
@export var icon: TextureRect
@export var count: Label

func update_display():
    if current.size() != 0:
        icon.texture = current["Inventory"]["texture"]
        count.text = str(current["Count"] if current["Inventory"]["stack"] else "")
    else:
        icon.texture = null
        count.text = ""

func _enter_tree() -> void:
    current = GameManager.game.character.character_resource.hold.hold_inventory[int(name)]

func get_popup_position():
    var gp = get_global_mouse_position()
    return Vector2(gp.x + 10, gp.y - GameManager.game.inventory_info_popup.root.size.y)

func reset():
    %Back.visible = false

func set_current():
    %Back.visible = true

func on_left_click():
    super.on_left_click()
    hold.update_current_select(int(name))
