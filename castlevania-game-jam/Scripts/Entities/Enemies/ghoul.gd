extends Enemy
class_name Ghoul

@onready var animation_player: AnimationPlayer = $AnimationPlayer

#state machine. Ghoul will not move until enters chase state
@export var state : STATES = STATES.RISE
enum STATES {RISE, CHASE, RETURN}

func _ready() -> void:
	player = $"../../Player"

func _physics_process(delta: float) -> void:
	if position.x > player.position.x + 32:
		velocity.x = -move_speed
		sprite.flip_h = false
	elif  position.x < player.position.x - 32:
		velocity.x = move_speed
		sprite.flip_h = true
	
	if state == STATES.CHASE: 
		move_and_slide()
		animation_player.play("Chase")


func _on_existance_timer_timeout() -> void:
	state = STATES.RETURN
	animation_player.play("Return")
