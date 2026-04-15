extends Enemy
class_name Fishman

@onready var shot_timer: Timer = $ShotTimer
@onready var direction_timer: Timer = $DirectionTimer

#state machine
enum STATES {INITIALIZE, PROCESS}
@export var state : STATES = STATES.INITIALIZE:
	set(wish_state):
		state = wish_state
		if state == STATES.INITIALIZE:
			pass
		if state == STATES.PROCESS:
			dir = 1
			direction_timer.start(randf_range(min_time, max_time))
			shot_timer.start()
			$AnimationPlayer.play("Walk")

#projectile
const FIREBALL = preload("uid://dhw3wje3b4to2")
var fireball_direction : int = 1

#timer values
var min_time : float = 0.1
var max_time : float = 0.7

#func _ready() -> void:
	#dir = 1
	#direction_timer.start(randf_range(0.1, 0.5))

func _physics_process(delta: float) -> void:
	if position.x < player.position.x:
		sprite.flip_h = true
		fireball_direction = 1

	else:
		sprite.flip_h = false
		fireball_direction = -1

	set_direction()
	move_and_slide()
	

#overrided function because enemy should always face player
func set_direction() -> void:
	match dir:
		1: 
			velocity.x = move_speed
		-1: 
			velocity.x = -move_speed

#spawns a fireball once timer expires and there are less than two fireballs on screen
func _on_shot_timer_timeout() -> void:
	if get_tree().get_node_count_in_group("Enemy Projectiles") < 1:
		var fireball_instance : Node = FIREBALL.instantiate()
		add_sibling(fireball_instance)
		fireball_instance.position = position
		fireball_instance.dir = fireball_direction

#switches movement direction randomly every few frames
func _on_direction_timer_timeout() -> void:
	dir = -dir
	direction_timer.start(randf_range(min_time, max_time))
