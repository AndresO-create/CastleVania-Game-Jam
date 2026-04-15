extends Node
class_name Main

signal update_area(wish_area : int)
@export_range(-1, 3, 1, "prefer_slider") var start_level : int = 0

@onready var player: Player = $Player
const LEVEL_1_1 = preload("uid://ddhwlf4dxef3r")
const LEVEL_1_2 = preload("uid://dai7jqv4beuco")
const LEVEL_1_3 = preload("uid://3443lhu2x3ge")
const LEVEL_1_4 = preload("uid://c1j6btigncx7s")

var level_list : Array = [LEVEL_1_1, LEVEL_1_2, LEVEL_1_3, LEVEL_1_4]
var current_level : PackedScene

func _ready() -> void:
	load_level(start_level)

func reload_level() -> void:
	load_level(GameManager.current_level)

func next_level() -> void:
	GameManager.current_level += 1
	load_level(GameManager.current_level)

func load_level(level_index : int) -> void:
	var level_instance : Node
	if level_index != -1: level_instance = level_list[level_index].instantiate()
	else: level_instance = load("res://Scenes/Levels/test_level.tscn").instantiate()
	add_child(level_instance)
	player.position = level_instance.player_spawn.position
	current_level = level_list[level_index]
	update_area.emit(level_index + 1)
