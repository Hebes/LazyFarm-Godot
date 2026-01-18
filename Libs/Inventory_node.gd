class_name InventoryNode

extends InterfaceNode

## { inventory:Inventory,count:int }
var current: Dictionary

func _ready() -> void:
    update_display()

func update_display():
    if current.size() != 0:
        %Icon.texture = current["Inventory"]["texture"]
        %Count.text = str(current["Count"] if current["Inventory"]["stack"] else "")
    else:
        %Icon.texture = null
        %Count.text = ""

func on_mouse_enter():
    super.on_mouse_enter()
    if current.size() == 0:
        return
    GameManager.game.inventory_info_popup.set_current_inventory(self)
    GameManager.game.inventory_info_popup.show_popup()

func on_mouse_exit():
    super.on_mouse_exit()
    if current.size() == 0:
        return
    GameManager.game.inventory_info_popup.hide_popup()

func on_move():
    super.on_move()
    if current.size() == 0:
        return
    GameManager.game.inventory_info_popup.update_popup(get_popup_position())

func get_popup_position():
    return get_global_mouse_position() + Vector2(10, 0)

## 获取当前拖拽数据
func _get_drag_data(at_position: Vector2) -> Variant:
    if current.size() == 0:
        return null
    else:
        #create_preview(self, at_position)
        set_drag_preview(create_preview2(self,at_position))
        return {
            "type": "Inventory",
            "target": self
        }

## 能够拖拽的数据
func _can_drop_data(_at_position: Vector2, target: ) -> bool:
    return target.has("type") && target["type"] == "Inventory" && target["target"] != self

## 拖拽数据
func _drop_data(at_position: Vector2, data) -> void:
    var target: InventoryNode = data["target"]
    exchange_inventory(self, target)
    GameManager.game.inventory_info_popup.set_current_inventory(self)
    GameManager.game.inventory_info_popup.show_popup()

## 交换物品
static func exchange_inventory(i1: InventoryNode, i2: InventoryNode):
    var origin = i1.current
    var target = i2.current
    if origin.size() == 0:
        origin["Inventory"] = target["Inventory"]
        origin["Count"] = target["Count"]
        target.clear()
    else:
        var temp = {
            "Inventory": origin["Inventory"],
            "Count": origin["Count"],
        }
        origin["Inventory"] = target["Inventory"]
        origin["Count"] = target["Count"]
        target["Inventory"] = temp["Inventory"]
        target["Count"] = temp["Count"]
    i1.update_display()
    i2.update_display()

    if i1 is HoldItem || i2 is HoldItem:
        var hold = GameManager.game.character.attribute.hold
        hold.update_current_select(hold.current_select)

## 创建快捷拖拽 set_drag_preview(create_preview2(self,at_position))
static func create_preview2(target: InventoryNode, offset: Vector2):
    var container := Control.new()
    container.z_index = 1000
    container.mouse_filter = Control.MOUSE_FILTER_IGNORE
    var preview : InventoryNode =target.duplicate()
    preview.modulate.a = 0.5
    preview.position = -offset
    container.add_child(preview)
    return container
    
#static func create_preview(target: InventoryNode, offset: Vector2):
    #var node: InventoryPreview = ResourceManager.load_resource("res://compoents/inventory_preview/inventory_preview.tscn").instantiate()
    #node.inventory_node.current = target.current
    #node.center = offset
    #node.inventory_node.modulate.a = 0.5
    #GameManager.game.add_child(node)
