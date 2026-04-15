extends Area2D
class_name GhoulSpawner

@onready var spawn_timer: Timer = $SpawnTimer

@export var min_time : float 
@export var max_time : float

@export var min_pos : float
@export var max_pos : float

@export var max_on_screen : int = 3

@onready var player : Player = $"../../Player"

func _on_body_entered(body: Node2D) -> void:
	if spawn_timer.is_stopped():
		spawn_timer.start(randf_range(min_time, max_time))


func _on_spawn_timer_timeout() -> void:
	if get_tree().get_node_count_in_group("Ghouls") < max_on_screen:
		var ghoul : Node = load("res://Scenes/Entities/Enemies/ghoul.tscn").instantiate()
		add_sibling(ghoul)
		var ghoul_pos : int = randi_range(0, 1)
		if ghoul_pos:
			ghoul.position = Vector2(player.position.x - min_pos, position.y)
		else:
			ghoul.position = Vector2(player.position.x + max_pos, position.y)
