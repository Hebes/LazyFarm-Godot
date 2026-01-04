# Copilot / AI Agent Instructions for Farm (Godot 4.5)

Purpose: concise, actionable guidance for an AI coding agent to be productive immediately in this repository.

## Quick context
- Godot 4.5 project (see `project.godot`).
- Core singletons (autoloads): `LoadingManager` (scene), `ResourceManager` (script), `ImGuiRoot` (scene). These are defined in `project.godot` and assumed available globally.
- Scene layout clue: levels live under `res://Scene/Level/<LevelName>/<LevelName>.tscn` (see `Scene/Level` and `Game.gd`).

## Architecture / key patterns
- Singletons: `ResourceManager` handles resource loading (sync and threaded async). Use it for reading `.tres`, `.tscn`, and other resources.
  - Async API: `ResourceManager.load_resource_async(path, callback: Callable, process: Callable)`
    - callback receives the loaded Resource object.
    - process receives a progress value (float, 0..1) — callers should name and use this float; note a small bug in `Game.gd` where the progress variable is referenced as `progress` although the parameter is named differently.
- Level loading: `Scene/Level/Game/Game.gd::Load_Level` builds path using `LEVEL_TYPE` mapping and calls `ResourceManager.load_resource_async` then instantiates and swaps `current_level_instance`.
  - Before swap: call `save()` and `queue_free()` on the prior instance if exists.
  - After attach: call `set_character_postion()`, `camera.set_limit()`, `camera.set_follow_target(character)`, emit `level_loaded` signal.
  - Loading UX uses `LoadingManager.enter(...)` and `LoadingManager.leave(...)`. The enter/leave pattern passes a center `Vector2` (typically from `UtilsManager.get_screen_position(character.graphics).position`) and accepts a callback.
- Seasonal tiles: `Game.gd::Switch_Season` expects per-layer TileMap layers to have metadata `seasonal = true`. Seasonal tilesets are stored at `res://Sprite/TileSet/<Season>/<Season>.tres`.
- Debug UI: `addons/imgui-godot` is included and autoloaded as `ImGuiRoot`; scripts use `ImGui.Begin`, `ImGui.Button` in `_process` to provide in-game debug controls.

## Conventions and notable idioms
- Enums + mapping constants: enum values are mapped to folder/asset names via dictionaries like `LEVEL_TYPE` and `SEASON` (see `Game.gd`). Follow this pattern when adding new levels/seasons.
- Async pattern: after instantiating an async-loaded scene, many places `await get_tree().process_frame` is used before emitting signals or continuing — follow that when you need a frame boundary.
- LoadingManager uses a shader-driven `ColorRect` animation and exposes methods: `enter(center, invent, callback)`, `leave(center, callback)`, `enter_force()`, `leave_force()`.
- Saving + freeing: `Level` instances are expected to implement `save()` before being freed; search for `save()` on level nodes if you modify level lifecycle.

## Files / directories to reference
- `project.godot` — autoloads and engine version
- `Scene/Level/*` — level scenes and `Level.gd` (helper: `get_all_tile_map_layers()`)
- `Scene/Level/Game/Game.gd` — main game-level logic (loading, season switching, debug hooks)
- `Script/Manager/Resource/Resource_Manager.gd` — loader utilities (threaded load)
- `Script/Manager/Loading/loading_manager.gd` + `LoadingManager.tscn` — loading UX
- `addons/imgui-godot/` — debug UI integration
- `Sprite/TileSet/<Season>/` — seasonal tilesets (expected naming pattern: `<Season>.tres`)

## Common pitfalls & TODOs for AI edits
- ResourceManager.process callback signature must accept and use a float progress value; avoid referencing undefined variable names.
- When switching levels: ensure old level `save()` is called if applicable, and avoid racing with async load callbacks (use LoadingManager callbacks and `await get_tree().process_frame` when needed).
- Verify metadata usage: seasonal layers rely on `has_meta('seasonal') && get_meta('seasonal')` — adding seasonal tiles should add that meta.
- Some manager scripts are scenes (e.g., `LoadingManager`) while others are scripts (e.g., `ResourceManager`). Do not assume both are plain scripts.

## Example code snippets (referenced locations)
- Level path pattern (from `Game.gd`):
  - `"res://Scene/Level/%s/%s.tscn" % [LEVEL_TYPE[level], LEVEL_TYPE[level]]`
- Async loader usage (from `Game.gd`):
  - `ResourceManager.load_resource_async(level_path, func(scene: Resource): ... , func(process: float): ... )`
- Season tileset load (from `Game.gd`):
  - `ResourceManager.Load_resource("res://Sprite/TileSet/%s/%s.tres" % [SEASON[season],SEASON[season]])`

## If you need to make a change
- Update or add tests and validate in the Godot Editor (Godot 4.5). Run the project and exercise level load and season-switch flows.
- For UI or debug changes, use the ImGui debug menu rather than adding temporary UI nodes.

---
If you'd like, I can open more scenes and scan for missing references (e.g., `SoundManager`, `UtilsManager`, `character` implementation) and extend this document with exact file references and example diffs. Please tell me which areas you'd like more detail on. ✅
