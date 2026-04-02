extends CharacterBody2D
##contains fundemental interactions between enemy and player. Will damage player if hitbox is entered, will be damaged if hit by whip and will interact with terrain
class_name Enemy

@export var move_speed : float = 32.0
@export var health : int = 1
@export var damage : int = 1

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir : int


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func destroy_enemy() -> void:
	GameManager.explosion.play()
	queue_free()

func damage_enemy(damage : int) -> void:
	health -= damage
	if health <= 0:
		destroy_enemy()
		
##turn enemy around if an edge is detected **MUST HAVE EDGE DETECTION COMPONENT ATTACHED**
func detect_edge() -> void:
	dir = dir * -1

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.knockback_dir = abs(velocity.x)/velocity.x
		body.current_state = body.STATES.DAMAGE
		body.health -= damage


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
