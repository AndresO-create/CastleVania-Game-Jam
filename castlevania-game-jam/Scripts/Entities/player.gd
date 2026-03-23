extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var neck_sprite: Sprite2D = $Sprite/NeckSprite

@onready var sprite_shader : ShaderMaterial = $Sprite.material
@onready var small_hitbox_collision: CollisionShape2D = $Sprite/HitboxSmall/HitboxCollision
@onready var large_hitbox_collision: CollisionShape2D = $Sprite/HitboxLarge/HitboxCollision
@onready var hitbox: CollisionShape2D = $Collision

@export_category("Movement")
@export var walk_velocity : float = 16.0
@export var jump_velocity : float = -32.0
@export var jump_fall_speed : float = 32.0
@export var fall_speed : float = 64.0

@export_category("Stats")
@export var health : int = 6
@export var score : int = 0

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
				animation_player.play("Jump")
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
				#attack_state()
			STATES.DAMAGE:
				damage_state()
			STATES.DEATH:
				death_state()
		
		#disable necksprite hitbox if not currently attacking
		if current_state != STATES.ATTACK:
			$Sprite/NeckSprite.visible = false
@export var whip_state : WHIP_STATES

@export_category("Palettes")
@export var palette_a : CompressedTexture2D
@export var palette_b : CompressedTexture2D
@export var palette_c : CompressedTexture2D

#state machine
##list of possible movement states for the player. Controls the values of the current_state and previous_state variables
enum STATES {IDLE, WALK, CROUCH, JUMP, FALL, ATTACK, DAMAGE, DEATH}
var previous_state : STATES
##states which cannot be interrupted until they are completed
var static_states : Array = [STATES.JUMP, STATES.ATTACK, STATES.CROUCH]
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
			STATES.DAMAGE:
				return "DAMAGE"
			STATES.DEATH:
				return "DEATH"
			_:
				return "Uhhh...."

##keeps track of whip level
enum WHIP_STATES {ZERO, ONE, TWO}

#other
##current direction the player is moving towards
var dir : int


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("JUMP") and is_on_floor():
		current_state = STATES.JUMP

	if event.is_action_pressed("ATTACK"):
		current_state = STATES.ATTACK

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
	dir = Input.get_axis("LEFT", "RIGHT")
	#locks player horizontal speed if the player is airborne
	if is_on_floor() and current_state not in static_states:
		if dir:
			current_state = STATES.WALK
		else:
			velocity.x = 0.0
			if current_state not in static_states:
				current_state = STATES.IDLE

		match  dir:
			-1:
				sprite.scale.x = -1
			1:
				sprite.scale.x = 1
	

	move_and_slide()
		
		
func walk_state() -> void:
	#animation_player.play("Walk")
	velocity.x = walk_velocity * dir

func jump_state() -> void:
	#animation_player.play("Jump")
	velocity.y = jump_velocity


func fall_state(delta : float) -> void:
	#velocity.y += fall_speed * delta
	apply_gravity(fall_speed, delta)
	pass

func attack_state() -> void:
	#await get_tree().create_timer(0.25).timeout
	
	match whip_state:
		WHIP_STATES.ZERO, WHIP_STATES.ONE:
			neck_sprite.frame = 0
			small_hitbox_collision.disabled = false
			
		WHIP_STATES.TWO:
			neck_sprite.frame = 1
			large_hitbox_collision.disabled = false
	
	#disable hitboxes at end of animation
	await get_tree().create_timer(0.75).timeout
	get_tree().set_group("Hitboxes", "disabled", true)

func damage_state() -> void:
	pass
	
func death_state() -> void:
	pass

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


func _on_hitbox_small_body_entered(body: Node2D) -> void:
	if body is Enemy:
		match whip_state:
			WHIP_STATES.ZERO:
				body.damage_enemy(1)
			WHIP_STATES.ONE, WHIP_STATES.TWO:
				body.damage_enemy(2)
