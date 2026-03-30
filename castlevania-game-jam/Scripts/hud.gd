extends CanvasLayer
@onready var current_weapon: Sprite2D = $Subweapon/CurrentWeapon
@onready var ammo: Label = $Ammo
@onready var score: Label = $Score
@onready var health_bar: TextureProgressBar = $HealthBar

func _on_player_update_ammo(wish_ammo : int) -> void:
	ammo.text = str("Ammo: ", wish_ammo)

func _on_player_update_health(wish_health : int) -> void:
	health_bar.value = wish_health
	print("UPDATED HEALTH BAR")
	print(wish_health)

func _on_player_update_score(wish_score : int) -> void:
	score.text = str("Score: ", wish_score)


func _on_player_update_subweapon(wish_subweapon : Player.SUB_WEAPONS) -> void:
	match wish_subweapon:
		Player.SUB_WEAPONS.NONE:
			current_weapon.frame = 15
		Player.SUB_WEAPONS.DAGGER:
			current_weapon.frame = 0
		Player.SUB_WEAPONS.CROSS:
			current_weapon.frame = 1
		Player.SUB_WEAPONS.AXE:
			current_weapon.frame = 5
		Player.SUB_WEAPONS.HOLY_WATER:
			current_weapon.frame = 9
	
