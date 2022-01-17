extends Node

var level = 0
var max_level
var playing = false
var tile_size = 8

# [max_monsters, spawn_time, total_time]
var _levels = [
    [2, 3, 5],
    [3, 3, 10],
    [4, 3, 20],
    [5, 3, 20],
]
var levels = {}

func _ready():
    randomize()
    
    # create the levels dictionary. this is done dynamically so 
    # that you can edit the _levels array without making sure
    # the keys match up
    for i in range(0, _levels.size()):
        levels[i+1] = _levels[i]
    max_level = _levels.size()


func get_level_data():
    if (!level in levels):
        return []
    else:
        return levels[level]
