extends Item
class_name WeaponUpgrade
#to-do: create sprite that will alternate between II and III depending on player weapon_level
@onready var player : Player =  $"../../Player"
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	match player.weapon_level:
		Player.WEAPON_LEVELS.ZERO:
			sprite.frame = 0
		_:
			sprite.frame = 1

func _on_hitbox_body_entered(body: Node2D) -> void:
	match body.weapon_level:
		body.WEAPON_LEVELS.ZERO:
			body.weapon_level = body.WEAPON_LEVELS.ONE
		body.WEAPON_LEVELS.ONE:
			body.weapon_level = body.WEAPON_LEVELS.TWO
		body.WEAPON_LEVELS.TWO:
			return

	queue_free()
