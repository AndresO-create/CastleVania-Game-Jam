extends Enemy
@onready var target : Marker2D = $Target

enum STATES {WAIT, CHASE, JUMP}
var state : STATES = STATES.WAIT
var player : Player

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if state == STATES.CHASE:
		chase_state()

	move_and_slide()
	
func chase_state() -> void:
	velocity.x = move_speed * dir
	target.position.x = player.position.x
	
	if position.x < target.position.x:
		dir = 1
	elif position.x > target.position.x:
		dir = -1

func _on_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		state = STATES.CHASE
		target.position.x = body.position.x
		player = body
