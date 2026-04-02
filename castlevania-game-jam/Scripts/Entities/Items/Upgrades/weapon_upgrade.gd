extends Item
class_name WeaponUpgrade
#to-do: create sprite that will alternate between II and III depending on player weapon_level

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		match body.weapon_level:
			body.WEAPON_LEVELS.ZERO:
				body.weapon_level = body.WEAPON_LEVELS.ONE
			body.WEAPON_LEVELS.ONE:
				body.weapon_level = body.WEAPON_LEVELS.TWO
			body.WEAPON_LEVELS.TWO:
				return
