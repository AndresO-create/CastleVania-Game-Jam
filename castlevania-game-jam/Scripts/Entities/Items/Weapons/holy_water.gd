extends Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

#state machine
##keep track of if the bottle is being thrown or if it has hit the ground/floor. If the bottle is in its BREAK state, it will unleash an AOE hitbox that will chip away at enemies health
enum STATES {THROW, BREAK}
var current_state = STATES.THROW

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var initial_velocity : float = 128.0

func _ready() -> void:
	velocity.x = initial_velocity * dir
	velocity.y = -128.0
	
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor():
		velocity = Vector2.ZERO
		current_state = STATES.BREAK
		animation_player.play("Break")
		
	move_and_slide()
