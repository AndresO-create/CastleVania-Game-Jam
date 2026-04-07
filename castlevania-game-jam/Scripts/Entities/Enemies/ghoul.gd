extends Enemy
class_name Ghoul

@onready var player: Player = $"../../Player"
@onready var sprite: Sprite2D = $Sprite

#state machine. Ghoul will not move until enters chase state
@export var state : STATES = STATES.RISE
enum STATES {RISE, CHASE}

func _physics_process(delta: float) -> void:
	if position.x > player.position.x + 32:
		velocity.x = -move_speed
		sprite.flip_h = false
	elif  position.x < player.position.x - 32:
		velocity.x = move_speed
		sprite.flip_h = true
	
	if state == STATES.CHASE: move_and_slide()
