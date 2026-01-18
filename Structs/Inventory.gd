class_name Inventory

extends Resource

enum InventoryType {
    Weapon, ## 武器
    Armor, ## 防具
    Material, ## 材料
    Seed, ## 种子
    Food, ## 食物
    Medicine, ## 药品
    Tool, ## 工具
    Crop, ## 果实
    Building ## 建筑
}

const INVENTORY_TYPE = {
    InventoryType.Weapon: "武器",
    InventoryType.Armor: "防具",
    InventoryType.Material: "材料",
    InventoryType.Seed: "种子",
    InventoryType.Food: "食物",
    InventoryType.Medicine: "药品",
    InventoryType.Tool: "工具",
    InventoryType.Crop: "果实",
    InventoryType.Building: "建筑",
}

@export var id: int ## 物品ID
@export var texture: AtlasTexture ## 物品贴图
@export var highlight_texture: AtlasTexture ## 高亮贴图
@export var name: String ## 物品名称
@export var description: String ## 物品描述
@export var type: InventoryType ## 物品类型
@export var price: int ## 物品交割
@export var stack: bool ## 是否可堆叠
@export var lift: bool ## 是否可以举起
