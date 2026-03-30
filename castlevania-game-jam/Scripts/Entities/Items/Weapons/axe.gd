extends Weapon
@export var initial_velocity : Vector2 = Vector2(61.3, -245)
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity.x = initial_velocity.x * dir
	velocity.y = initial_velocity.y

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
