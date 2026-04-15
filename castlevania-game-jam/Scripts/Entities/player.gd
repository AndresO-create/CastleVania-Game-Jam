extends CharacterBody2D
class_name Player

#signals
signal update_ammo(wish_ammo : int)
signal update_subweapon(wish_subweapon : SUB_WEAPONS)
signal update_health(wish_health : int)
signal update_weapon_level(wish_weapon_level : WEAPON_LEVELS)

#onready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var neck_sprite: Sprite2D = $Sprite/NeckSprite

@onready var sprite_shader : ShaderMaterial = $Sprite.material
@onready var small_hitbox_collision: CollisionShape2D = $Sprite/HitboxSmall/HitboxCollision
@onready var large_hitbox_collision: CollisionShape2D = $Sprite/HitboxLarge/HitboxCollision
@onready var hitbox: CollisionShape2D = $Collision

@onready var intangibility_timer: Timer = $IntangibilityTimer

#export variables
@export_category("Movement")
@export var walk_velocity : float = 32.0
@export var jump_velocity : float = -192.0
@export var jump_fall_speed : float = 384.0
@export var fall_speed : float = 512.0
@export var knockback : Vector2 = Vector2(-96, -128)

@export_category("Stats")
@export_range(0, 10, 1, "prefer_slider") var health : int = 10:
	set(wish_health):
		health = wish_health
		update_health.emit(health)
		if health == 0:
			animation_player.play("Death")
			death_state()
	get():
		return clamp(health, 0, MAX_HEALTH)
@export_range(0, MAX_AMMO, 1, "prefer_slider") var ammo : int = 0:
	set(wish_ammo):
		ammo = wish_ammo
		update_ammo.emit(ammo)
	get():
		return clamp(ammo, 0, MAX_AMMO)

@export_category("States")
@export var current_state : STATES:
	set (wish_state):
		var delta : float = get_physics_process_delta_time()
		if current_state != wish_state : 
			previous_state = current_state
			current_state = wish_state
			
		match (current_state):
			STATES.IDLE:
				animation_player.play("Idle")
			STATES.WALK:
				animation_player.play("Walk")
				walk_state()
			STATES.CROUCH:
				animation_player.play("Crouch")
			STATES.JUMP:
				animation_player.play("Jump")
				jump_state()
			STATES.FALL:
				fall_state(delta)
			STATES.ATTACK:
				if previous_state == STATES.WALK or previous_state == STATES.CROUCH:
					velocity.x = 0
				
				if is_on_floor() and previous_state == STATES.CROUCH:
					animation_player.play("CrouchAttack")
				elif is_on_floor():
					animation_player.play("GroundAttack")
				else:
					animation_player.play("AirAttack")
			STATES.ITEM:
				if sub_weapon != SUB_WEAPONS.NONE and ammo and get_tree().get_node_count_in_group("Projectiles") < max_projectiles:
					animation_player.play("Item")
					item_state()
			STATES.DAMAGE:
				intangibility_timer.start()
				animation_player.play("Damage")
				damage_state()
			STATES.DEATH:
				animation_player.play("Death")
				death_state()
		
		#disable necksprite and neck hitbox if not currently attacking
		if current_state != STATES.ATTACK and current_state != STATES.FALL:
			neck_sprite.visible = false
			get_tree().set_group("Hitboxes", "disabled", true)

@export var whip_state : WHIP_STATES:
	set(wish_state):
		whip_state = wish_state
		if wish_state != WHIP_STATES.ZERO:
			$Sfx/PowerUp.play()
		call_deferred("update_palette")
@export var sub_weapon : SUB_WEAPONS:
	set(wish_weapon):
		sub_weapon = wish_weapon
		update_subweapon.emit(sub_weapon)
@export var weapon_level : WEAPON_LEVELS:
	set(wish_level):
		weapon_level = wish_level
		match weapon_level:
			WEAPON_LEVELS.ZERO:
				max_projectiles = 1
			WEAPON_LEVELS.ONE:
				$Sfx/PowerUp.play()
				max_projectiles = 2
			WEAPON_LEVELS.TWO:
				$Sfx/PowerUp.play()
				max_projectiles = 3
		
		update_weapon_level.emit(weapon_level)

@export_category("Palettes")
@export var palette_a : CompressedTexture2D
@export var palette_b : CompressedTexture2D
@export var palette_c : CompressedTexture2D

#state machine
##list of possible movement states for the player. Controls the values of the current_state and previous_state variables
enum STATES {IDLE, WALK, CROUCH, JUMP, FALL, ATTACK, ITEM, DAMAGE, DEATH}
var previous_state : STATES
##states which cannot be interrupted until they are completed
var static_states : Array = [STATES.JUMP, STATES.ATTACK, STATES.CROUCH, STATES.DAMAGE]
##returns current player state in string form
var state_string : String:
	get:
		match(current_state):
			STATES.IDLE:
				return "IDLE"
			STATES.WALK:
				return "WALK"
			STATES.CROUCH:
				return "CROUCH"
			STATES.JUMP:
				return "JUMP"
			STATES.FALL:
				return "FALL"
			STATES.ATTACK:
				return "ATTACK"
			STATES.ITEM:
				return "ITEM"
			STATES.DAMAGE:
				return "DAMAGE"
			STATES.DEATH:
				return "DEATH"
			_:
				return "Uhhh...."

##keeps track of whip level
enum WHIP_STATES {ZERO, ONE, TWO}

##keeps track of current sub-weapon
enum SUB_WEAPONS {NONE, DAGGER, CROSS, AXE, HOLY_WATER}

##keeps track of weapon level
enum WEAPON_LEVELS {ZERO, ONE, TWO}

#other
##current direction the player is moving towards
var dir : int

##direction the player will be knocked towards during enemy interactions
var knockback_dir : int

#max values
##max number of projectiles allowed on screen. NOTE: Not a constant because it increases in proportion to the WEAPON_LEVEL state
var max_projectiles : int = 1

##maximum health
const MAX_HEALTH : int = 10

##maximum ammo
const MAX_AMMO : int = 99

#subweapons to be instantiated
const AXE = preload("uid://bv0dg1jth5c1l")
const CROSS = preload("uid://dryfa5l6dywj7")
const DAGGER = preload("uid://5pt7menxjpeq")
const HOLY_WATER = preload("uid://cfvcxvp2j8j3v")

func _input(event: InputEvent) -> void:
	#handle jump
	if event.is_action_pressed("JUMP") and is_on_floor():
		current_state = STATES.JUMP

	if event.is_action_released("JUMP") and current_state == STATES.JUMP:
		velocity.y /= 2

	#handle attack
	if event.is_action_pressed("ATTACK"):
		current_state = STATES.ATTACK
	
	#handle subweapon
	if event.is_action_pressed("ITEM"):
		current_state = STATES.ITEM
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("DOWN") and is_on_floor() and current_state != STATES.ATTACK:
		velocity.x = 0
		current_state = STATES.CROUCH
	if Input.is_action_just_released("DOWN"):
		current_state = STATES.IDLE
		hitbox.scale = Vector2(1,1)
		hitbox.position.y = 0

	if !is_on_floor():
		if velocity.y >= 0:
			current_state = STATES.FALL
		else:
			apply_gravity(jump_fall_speed, delta)
		
	if previous_state == STATES.FALL:
		current_state = STATES.IDLE

	@warning_ignore("narrowing_conversion")
	dir = Input.get_axis("LEFT", "RIGHT")
	#locks player horizontal speed if the player is airborne
	if is_on_floor() and current_state not in static_states:
		if dir:
			current_state = STATES.WALK
		elif current_state != STATES.DAMAGE:
			velocity.x = 0
			if current_state not in static_states:
				current_state = STATES.IDLE

		match  dir:
			-1:
				sprite.scale.x = -1
			1:
				sprite.scale.x = 1
	

	move_and_slide()
		
		
func walk_state() -> void:
	velocity.x = walk_velocity * dir

func jump_state() -> void:
	velocity.y = jump_velocity


func fall_state(delta : float) -> void:
	apply_gravity(fall_speed, delta)

func attack_state() -> void:	
	match whip_state:
		WHIP_STATES.ZERO, WHIP_STATES.ONE:
			neck_sprite.frame = 0
			small_hitbox_collision.disabled = false
			
		WHIP_STATES.TWO:
			neck_sprite.frame = 1
			large_hitbox_collision.disabled = false
	
	
func item_state() -> void:
	ammo -= 1
	match sub_weapon:
		SUB_WEAPONS.DAGGER:
			instantiate_subweapon(DAGGER)
		SUB_WEAPONS.AXE:
			instantiate_subweapon(AXE)
		SUB_WEAPONS.CROSS:
			instantiate_subweapon(CROSS)
		SUB_WEAPONS.HOLY_WATER:
			instantiate_subweapon(HOLY_WATER)

##helper function for item_state that instantiates item
func instantiate_subweapon(SUB_WEAPON : PackedScene):
	var weapon_instance : Node = SUB_WEAPON.instantiate()
	add_sibling(weapon_instance)
	weapon_instance.position = position
	weapon_instance.dir = sprite.scale.x
	weapon_instance.sprite.scale.x = weapon_instance.dir

func damage_state() -> void:
	#check if player has > 0 health
	if health == 0:
		current_state = STATES.DEATH
		return
	velocity.y = knockback.y
	velocity.x = knockback.x * knockback_dir
	$Sfx/Hurt.play()
	sprite_shader.set_shader_parameter("opacity_diff", 0.5)
	
	
func death_state() -> void:
	#pause game and play game over theme
	get_tree().paused = true
	GameManager.spooky.stop()
	GameManager.game_over.play()
	#reset level and resume game
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	#get_tree().reload_current_scene()
	var main : Main = $".."
	main.get_child(2).queue_free()
	main.reload_level()
	
	
	#reset stats
	whip_state = WHIP_STATES.ZERO
	sub_weapon = SUB_WEAPONS.NONE
	weapon_level = WEAPON_LEVELS.ZERO
	health = MAX_HEALTH
	ammo = 0
	current_state = STATES.IDLE
	
	
	#reset shader
	sprite_shader.set_shader_parameter("opacity_diff", 0.0)
	
	#continue music
	GameManager.spooky.play()

##increases player's y-velocity if they are not grounded. 
func apply_gravity(gravity : float, delta : float) -> void:
	velocity.y += gravity * delta

##update player's sprite palette depending on whip_state
func update_palette() -> void:
	match (whip_state):
		WHIP_STATES.ZERO:
			sprite_shader.set_shader_parameter("output_palette_texture", palette_a)
		WHIP_STATES.ONE:
			sprite_shader.set_shader_parameter("output_palette_texture", palette_b)
		WHIP_STATES.TWO:
			sprite_shader.set_shader_parameter("output_palette_texture", palette_c)

##handle damage to enemies
func damage_enemy(body : Node2D) -> void:
	if body is Enemy:
		match whip_state:
			WHIP_STATES.ZERO:
				body.damage_enemy(1)
			WHIP_STATES.ONE, WHIP_STATES.TWO:
				body.damage_enemy(2)

func _on_hitbox_small_body_entered(body: Node2D) -> void:
	damage_enemy(body)


func _on_hitbox_large_body_entered(body: Node2D) -> void:
	damage_enemy(body)


#recets opacity of sprite_shader back to 1.0
func _on_intangibility_timer_timeout() -> void:
	sprite_shader.set_shader_parameter("opacity_diff", 0.0)
