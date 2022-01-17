extends Node2D

onready var player = $Player
onready var tilemap = $Navigation2D/TileMap1
onready var monsters = $Monsters

# UI nodes
onready var level_lbl = $CanvasLayer/TopUI/LevelLabel
onready var portal_bar = $CanvasLayer/TopUI/PortalBar
onready var monster_bar = $CanvasLayer/TopUI/MonsterBar
onready var portal_bar_tween = $CanvasLayer/TopUI/PortalBarTween
onready var monster_bar_tween = $CanvasLayer/TopUI/MonsterBarTween
onready var level_start_ui = $CanvasLayer/LevelStartUI
onready var level_start_lbl = $CanvasLayer/LevelStartUI/Rect/Label
onready var level_start_timer = $CanvasLayer/LevelStartUI/Rect/LevelStartTimer
onready var level_start_tween = $CanvasLayer/LevelStartUI/Rect/LevelStartTween

var portal = preload("res://Scenes/Portal.tscn")
var monster = preload("res://Scenes/Monster.tscn")
var won_menu = preload("res://Scenes/WonMenu.tscn")

var open_tile_id = 0

var spawn_buffer = 80
var monster_count = 0

var level_data
var max_monsters = 5
var spawn_time = 3
var target_time = 20


func get_open_position():
    var cells = tilemap.get_used_cells_by_id(open_tile_id)
    var cell_pos
    var filtered: Array = []
    for cell in cells:
        cell_pos = tilemap.map_to_world(cell)
        if player.global_position.distance_to(cell_pos) >= spawn_buffer:
            filtered.append(cell_pos)
    filtered.shuffle()
    return (filtered[0] + (Vector2.ONE * (Global.tile_size / 2)))


func spawn_monster():
    var m = monster.instance()
    m.position = get_open_position()

    monsters.add_child(m)
    monster_count += 1
    
    if monster_count > max_monsters:
        monsters.get_child(1).blink()
        monsters.get_child(0).queue_free()
        monster_count -= 1


func _ready():
    level_data = Global.get_level_data()
    if level_data.size() == 0:
        Global.playing = false
        add_child(won_menu.instance())
    else:
        max_monsters = level_data[0]
        spawn_time = level_data[1]
        target_time = level_data[2]
        
        level_lbl.text = "level " + str(Global.level) + "/" + str(Global.max_level)
        player.position = get_open_position()
        
        level_start_lbl.text = "level " + str(Global.level)
        level_start_timer.start(1.5)


func _on_LevelStartTimer_timeout():
    Global.playing = true
    
    level_start_timer.stop()
    level_start_tween.interpolate_property(level_start_ui, "modulate", Color(1, 1, 1, .8), Color(1, 1, 1, 0), 1.0)
    level_start_tween.start()

    for _i in range(max_monsters):
        spawn_monster()
    monsters.get_child(0).blink()
        
    monster_bar_tween.interpolate_property(monster_bar, "value", 0, 100, spawn_time)
    monster_bar_tween.start()
    portal_bar_tween.interpolate_property(portal_bar, "value", 0, 100, target_time)
    portal_bar_tween.start()


func _on_PortalBarTween_tween_completed(_object, _key):
    var _portal = portal.instance()
    add_child(_portal)
    _portal.position = get_open_position()
    _portal.fade_in()


func _on_MonsterBarTween_tween_completed(_object, _key):
    if Global.playing:
        spawn_monster()
        monster_bar_tween.interpolate_property(monster_bar, "value", 0, 100, spawn_time)
        monster_bar_tween.start()
    else:
        monster_bar_tween.stop_all()
