@tool

extends EditorPlugin

var main_screen_container: Control
var main_screen: InventoryEditor

## 是否显示在主窗口
func _has_main_screen() -> bool:
    return true

## 点击是否可见
func _make_visible(visible: bool) -> void:
    if !main_screen : return
    main_screen.visible = visible

## 插件名称
func _get_plugin_name() -> String:
    return "库存编辑器"

## 插件图标
func _get_plugin_icon() -> Texture2D:
    return preload("res://addons/Inventory_Editor/Icon.atlastex")


func _enter_tree() -> void:
    main_screen_container = get_editor_interface().get_editor_main_screen()

    main_screen = preload("res://addons/Inventory_Editor/InventoryEditor.tscn").instantiate()

    main_screen_container.add_child(main_screen)

    main_screen.visible = false

    main_screen_container.resized.connect(on_update_screen_size)
    
    main_screen.on_update_size(main_screen_container.size)

func on_update_screen_size():
    if !main_screen : return
    main_screen.on_update_size(main_screen_container.size)
