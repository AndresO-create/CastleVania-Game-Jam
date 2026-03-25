extends Enemy
enum STATES {IDLE, ACTIVE}
var state : STATES = STATES.IDLE
var target: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	match state:
		STATES.IDLE:
			return
		STATES.ACTIVE:
			animation_player.play("Active")
			active_state()
	#move_and_slide()
	
func active_state() -> void:
	var delta = get_physics_process_delta_time()
	position.x += move_speed * delta
	position.y = lerpf(position.y, target.position.y, -move_speed * delta *  delta)
	

func _on_detection_body_entered(body: Node2D) -> void:
	state = STATES.ACTIVE
	target = body
	
