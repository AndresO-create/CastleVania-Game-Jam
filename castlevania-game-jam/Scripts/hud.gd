extends CanvasLayer
@onready var current_weapon: Sprite2D = $Subweapon/CurrentWeapon
@onready var ammo: Label = $Ammo
@onready var area: Label = $Area
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var pause: Label = $Pause
@onready var player : Player = $"../Player"
@onready var weapon_upgrade_sprite: Sprite2D = $WeaponUpgradeSprite

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PAUSE"): 
		match pause.visible:
			false: 
				pause.visible = true 
				player.animation_player.pause()
			true: 
				pause.visible = false
				player.animation_player.play()

func _on_player_update_ammo(wish_ammo : int) -> void:
	ammo.text = str(wish_ammo)

func _on_player_update_health(wish_health : int) -> void:
	health_bar.value = wish_health
	
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
	
func _on_root_update_area(wish_area: int) -> void:
	area.text = str("Area: ",wish_area)


func _on_player_update_weapon_level(wish_weapon_level: Player.WEAPON_LEVELS) -> void:
	match wish_weapon_level:
		Player.WEAPON_LEVELS.ZERO:
			weapon_upgrade_sprite.visible = false
		Player.WEAPON_LEVELS.ONE:
			weapon_upgrade_sprite.visible = true
			weapon_upgrade_sprite.frame = 0
		Player.WEAPON_LEVELS.TWO:
			weapon_upgrade_sprite.visible = true
			weapon_upgrade_sprite.frame = 1
