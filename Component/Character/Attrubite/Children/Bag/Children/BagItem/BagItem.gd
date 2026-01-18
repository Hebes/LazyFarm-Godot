class_name BagItem

extends InventoryNode

@export var bag: Bag

func _enter_tree() -> void:
    current = GameManager.game.character.character_resource.bag.bag_inventory[int(name)]

## 测试代码

@export var icon: TextureRect
@export var count: Label

func update_display():
    if current.size() != 0:
        %Icon.texture = current["Inventory"]["texture"]
        %Count.text = str(current["Count"] if current["Inventory"]["stack"] else "")
    else:
        %Icon.texture = null
        %Count.text = ""
