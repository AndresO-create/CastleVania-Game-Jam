extends Enemy
@onready var target : Marker2D = $Target

@export var jump_velocity : Vector2 = Vector2(-32,-128.0)

enum STATES {IDLE, JUMP, FALL, CHASE}
var state : STATES = STATES.IDLE:
	set(wish_state):
		if state != wish_state:
			previous_state = state
			state = wish_state

var previous_state : STATES
var player : Player

func _physics_process(delta: float) -> void:
	$Label.text = str(state)
	if !is_on_floor():
		velocity.y += gravity*0.5 * delta
	
	match state:
		STATES.JUMP:
			$AnimationPlayer.play("Jump")
			jump_state()
		STATES.CHASE:
			$AnimationPlayer.play("Chase")
			chase_state()
		STATES.FALL:
			fall_state()

	move_and_slide()

func jump_state() -> void:
	if previous_state == STATES.IDLE:
		velocity = jump_velocity
		state = STATES.FALL

func fall_state() -> void:
	if is_on_floor():
		state = STATES.CHASE

func chase_state() -> void:
	$Sprite.scale.x = -1
	velocity.x = move_speed

func _on_detection_body_entered(body: Node2D) -> void:
	if state == STATES.IDLE:
		state = STATES.JUMP
