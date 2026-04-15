extends Enemy
class_name Wizard

@onready var detection: Area2D = $Detection

enum STATES {IDLE, DESCEND}
var state : STATES = STATES.IDLE:
	set (wish_state):
		state = wish_state
		if state == STATES.DESCEND:
			start_pos = position

var start_pos : Vector2

func _physics_process(delta: float) -> void:
	if state == STATES.DESCEND:
		queue_redraw()
		velocity.y += (gravity/2) * delta
	
	move_and_slide()
	
func _draw() -> void:
	if state == STATES.DESCEND:
		draw_line(start_pos, position, Color.WHITE, 2.0)


func _on_detection_body_entered(body: Node2D) -> void:
	state = STATES.DESCEND
