extends Node
class_name Root

@onready var player: Player = $Player
@export var start_level : int = 0
const LEVEL_1 = preload("uid://ddhwlf4dxef3r")
const LEVEL_2 = preload("uid://dai7jqv4beuco")
const LEVEL_3 = preload("uid://3443lhu2x3ge")
const LEVEL_4 = preload("uid://c1j6btigncx7s")

var level_list : Array = [LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4]
var current_level : PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PAUSE"):
		if get_tree().paused:
			get_tree().paused = false
		else: 
			get_tree().paused = true

func _ready() -> void:
	load_level(GameManager.current_level)
	

func reload_level() -> void:
	load_level(GameManager.current_level)

func next_level() -> void:
	GameManager.current_level += 1
	load_level(GameManager.current_level)
	print(GameManager.current_level)
	
func load_level(level_index : int) -> void:
	var level_instance : Node = level_list[level_index].instantiate()
	add_child(level_instance)
	player.position = level_instance.player_spawn.position
	current_level = level_list[level_index]
	print(current_level.to_string())
