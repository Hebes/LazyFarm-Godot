class_name InventoryInfoPopup

extends CanvasLayer


@export var root: PanelContainer

func _enter_tree() -> void:
    root.modulate.a = 0.0

## 设置当前物品
func set_current_inventory(target: InventoryNode):
    var inventory: Inventory = target.current["Inventory"]
    %Icon.texture = inventory["texture"]
    %Name.text = inventory["name"]
    %Type.text = Inventory.INVENTORY_TYPE[inventory["type"]]
    %Price.text = "价格：%s" % [inventory["price"]]
    %Description.text = inventory["description"]
    root.reset_size()

## 显示弹出
func show_popup():
    create_tween().tween_property(root, "modulate:a", 1.0, 0.1)

## 显示关闭
func hide_popup():
    create_tween().tween_property(root, "modulate:a", 0.0, 0.1)

## 更新弹出
func update_popup(at_position: Vector2):
    var root_size: Vector2 = UtilsManager.get_render_size()
    root.global_position = Vector2(clamp(at_position.x, 5, root_size.x - 5 - root.size.x), clamp(at_position.y, 5, root_size.y - 5 - root.size.y))
