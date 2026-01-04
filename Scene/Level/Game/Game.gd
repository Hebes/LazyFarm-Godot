## https://docs.godotengine.org/zh-cn/4.3

class_name Game

extends Node2D


var current_level_instance: Level


signal level_loaded


@export var character: Character ## 角色
@export var camera : Camera ## 摄像机
#@export var inventory_info_popup: InventoryInfoPopup
#@export var time_record: TimeRecord
#@export var game_resource: GameResource
#@export var global_light: GlobalLight
#@export var mouse_focus: MouseFocus
#@export var range_prompt: RangePrompt
#@export var pause_menu: PauseMenu

enum LevelType {
    Birth
}

const LEVEL_TYPE: Dictionary = {
    LevelType.Birth: "Birth"
}

enum Season {
    Spring,
    Summer,
    Fall,
    Winter
}

const SEASON: Dictionary = {
    Season.Spring: "Spring",
    Season.Summer: "Summer",
    Season.Fall: "Fall",
    Season.Winter: "Winter"
}

func _enter_tree() -> void:
    GameManager.game = self

func _exit_tree() -> void:
    GameManager.game = null


func _ready() -> void:
   Load_Level(LevelType.Birth)
 
## 离开场景
func Load_Level(level: LevelType):
    #game_resource.level = level
    var load_need_level = func(callback: Callable):
        var level_path: String = "res://Scene/Level/%s/%s.tscn" % [LEVEL_TYPE[level], LEVEL_TYPE[level]]
        print("加载关卡: %s" % level_path)
        ResourceManager.load_resource_async(level_path,
            func(scene: Resource):
                #var level_instance = scene.instantiate()
                current_level_instance = scene.instantiate()

                #if !level_instance: return

                #if current_level_instance:
                    #current_level_instance.save()
                    #current_level_instance.queue_free()
                    #current_level_instance = null
#
                #current_level_instance = level_instance
                add_child(current_level_instance)
                #current_level_instance.set_character_postion()
                camera.set_limit()
                camera.set_follow_target(character)
                # SoundManager.play_level_audio(game_resource.level)
                #await get_tree().process_frame
                level_loaded.emit()
                callback.call(),
            func(process : float):
                print("加载进度: %f" % process)
        )
    
    var position := Vector2(0.5,0.5)
    if current_level_instance:
        #var position := UtilsManager.get_screen_position(character.graphics).position
        LoadingManager.Enter(position, false, func():
                load_need_level.call(func():LoadingManager.Leave(position))
        )
    else:
        LoadingManager.enter_force()
        load_need_level.call( func():LoadingManager.Leave(position))
                

## 切换季节
func Switch_Season(season: Season) -> void:
    var switch = func():
        var tile_map_layers: Array[TileMapLayer] = []
        for child in current_level_instance.get_all_tile_map_layers():
            if child is TileMapLayer:
                if child.has_meta("seasonal") && child.get_meta("seasonal"):
                    tile_map_layers.push_back(child)

        var season_tileset_resource: Resource = ResourceManager.Load_resource("res://Sprite/TileSet/%s/%s.tres" % [SEASON[season],SEASON[season]])
        for layer in tile_map_layers:
            layer.tile_set = season_tileset_resource
     #var position := UtilsManager.get_screen_position(character.graphics).position
    var position := Vector2(0.5,0.5)
    LoadingManager.Enter(position, false, func():
        switch.call()
        LoadingManager.Leave(position))

## 测试切换季节
func _process(_delta: float) -> void:
    ImGui.Begin("Debug")
    if ImGui.Button("spring"):
      Switch_Season(Season.Spring)
      pass
    if ImGui.Button("Summer"):
      Switch_Season(Season.Summer)
      pass
    if ImGui.Button("Fall"):
      Switch_Season(Season.Fall)
      pass
    if ImGui.Button("Winter"):
      Switch_Season(Season.Winter)
      pass
    ImGui.End()
