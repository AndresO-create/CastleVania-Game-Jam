extends Enemy
class_name Ghoul

@onready var player: Player = $"../../Player"

#state machine. Ghoul will not move until enters chase state
@export var state : STATES = STATES.RISE
enum STATES {RISE, CHASE}

func _physics_process(delta: float) -> void:
	if position.x > player.position.x:
		velocity.x = -move_speed
	elif  position.x < player.position.x:
		velocity.x = move_speed
	
	if state == STATES.CHASE: move_and_slide()
