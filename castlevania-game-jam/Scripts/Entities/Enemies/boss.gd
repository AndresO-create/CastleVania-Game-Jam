extends Enemy
class_name Boss

#ends game once player touches object. To be spawned upon death
const ORB = preload("uid://ef3hkm18m303")

@export_category("Velocities")
@export var attack_speed : float = 128.0

@export_category("Timers")
@export var attack_state_time : float = 2.0
@export var wait_state_time : float = 1.0


#state machine
enum STATES {SLEEP, WAIT, ATTACK, RETURN, DEATH}
@export var state : STATES = STATES.SLEEP
@onready var state_timer: Timer = $StateTimer

#debug for states
@onready var debug_label: Label = $DebugLabel

#target for attack, return state
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
#@onready var player : Player = $"../../../Player"
var return_position : Vector2

#animations/sfx
@onready var damage_boss: AudioStreamPlayer = $DamageBoss
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	return_position = position
	
func _physics_process(delta: float) -> void:
	debug_label.text = str(state)
	match state:
		STATES.WAIT:
			animation_player.play("Wait")
			start_timer(wait_state_time)
			return
		STATES.ATTACK:
			animation_player.play("Attack")
			start_timer(attack_state_time)
			navigate(attack_speed)
		STATES.RETURN:
			animation_player.play("Return")
			if navigation_agent.is_navigation_finished():
				state = STATES.WAIT
			navigate(move_speed)
	if state != STATES.DEATH:
		move_and_slide()
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.knockback_dir = abs(velocity.x)/velocity.x
		body.current_state = body.STATES.DAMAGE
		body.health -= player_damage

func damage_enemy(damage : int) -> void:
	health -= damage
	damage_boss.play()
	if health <= 0:
		state = STATES.DEATH
		animation_player.play("Death")

func destroy_enemy() -> void:
	GameManager.explosion.play()
	var orb_instance = ORB.instantiate()
	add_sibling(orb_instance)
	orb_instance.position = return_position
	queue_free()

#helper function to make boss navigate towards position
func navigate(speed : float) -> void:
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = position.direction_to(next_path_position) * speed
	
#helper function to determine how long boss should be in state
func start_timer(time : float) -> void:
	if state_timer.is_stopped():
		state_timer.start(time)

func _on_state_timer_timeout() -> void:
	match state:
		STATES.WAIT:
			navigation_agent.target_position = player.position
			state = STATES.ATTACK
		STATES.ATTACK:
			navigation_agent.target_position = return_position
			state = STATES.RETURN
