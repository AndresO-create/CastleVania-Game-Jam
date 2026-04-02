@tool
extends Item
class_name WeaponItem

@export var weapon : Player.SUB_WEAPONS = Player.SUB_WEAPONS.NONE:
	set(wish_weapon):
		weapon = wish_weapon
		match weapon:
			Player.SUB_WEAPONS.DAGGER:
				$Sprite.set_deferred("frame", 0)
			Player.SUB_WEAPONS.CROSS:
				$Sprite.set_deferred("frame", 1)
			Player.SUB_WEAPONS.AXE:
				$Sprite.set_deferred("frame", 5)
			Player.SUB_WEAPONS.HOLY_WATER:
				$Sprite.set_deferred("frame", 9)
				
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		weapon = weapon
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		grant_weapon(body)
		queue_free()


func grant_weapon(player : Player) -> void:
	player.sub_weapon = weapon
