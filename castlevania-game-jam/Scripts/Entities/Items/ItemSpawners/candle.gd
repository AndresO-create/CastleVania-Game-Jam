extends Area2D
class_name Candle

##item to be spawned once player destroys candle
@export var spawn_item : PackedScene
@export var weapon_drop = Player.SUB_WEAPONS.DAGGER

func destroy_candle() -> void:
	if spawn_item != null:
		drop_item()
	queue_free()

##helper function to spawn item
func drop_item() -> void:
	var spawn_item_instance : Node = spawn_item.instantiate()
	call_deferred("add_sibling", spawn_item_instance)
	spawn_item_instance.position = position
	
	#allow for customizable weapon to spawn from candle
	if spawn_item_instance is WeaponItem: 
		match (weapon_drop):
			Player.SUB_WEAPONS.DAGGER:
				spawn_item_instance.weapon = Player.SUB_WEAPONS.DAGGER
			Player.SUB_WEAPONS.AXE:
				spawn_item_instance.weapon = Player.SUB_WEAPONS.AXE
			Player.SUB_WEAPONS.CROSS:
				spawn_item_instance.weapon = Player.SUB_WEAPONS.CROSS
			Player.SUB_WEAPONS.HOLY_WATER:
				spawn_item_instance.weapon = Player.SUB_WEAPONS.HOLY_WATER
	

func _on_area_entered(area: Area2D) -> void:
	destroy_candle()
