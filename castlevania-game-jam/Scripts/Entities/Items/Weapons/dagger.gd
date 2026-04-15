extends Weapon
@export var move_speed : float = 32.0

#func _init(direction : int, pos : Vector2) -> void:
	#dir = direction
	#position = pos

func _ready() -> void:
	velocity.x = move_speed * dir
 
func _physics_process(delta: float) -> void:
	move_and_slide()
