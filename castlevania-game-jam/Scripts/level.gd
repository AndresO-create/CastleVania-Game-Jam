extends Node2D
class_name Level
@onready var camera: Camera2D = $Camera
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var player : Player = $"../Player"
@onready var left_bound: CollisionShape2D = $Boundaries/LeftBound
@onready var right_bound: CollisionShape2D = $Boundaries/RightBound
@onready var boss_arena: Area2D = $BossArena


func _process(delta: float) -> void:
	camera.position.x = player.position.x

func _on_kill_plane_body_entered(body: Node2D) -> void:
	if body is Player:
		body.death_state()


func _on_level_transition_body_entered(body: Node2D) -> void:
	print("B")
	get_parent().call_deferred("next_level")
	call_deferred("queue_free")
	GameManager.transition.play()


#reset level bounds to accomodate for bossfight 
func _on_boss_arena_body_entered(body: Node2D) -> void:
	#camera.limit_left = boss_arena.position.x - 128.0
	camera.limit_left = move_toward(camera.limit_left, boss_arena.position.x - 128, get_process_delta_time())
	left_bound.position.x = boss_arena.position.x - 128.0
