extends Weapon
@export var move_speed : float = 512.0
@export var accel_speed : float = -512.0

func _ready() -> void:
	velocity.x = move_speed * dir
	
func _physics_process(delta: float) -> void:
	velocity.x += accel_speed * dir * delta
	move_and_slide()
