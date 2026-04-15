extends Node

@export_range(-1, 4, 1, "prefer_slider")
var current_level : int = 0


var whip_state = WHIP_STATES.ZERO
enum WHIP_STATES {ZERO, ONE, TWO}

#AUDIOBUS
@onready var explosion: AudioStreamPlayer = $AudioBus/Explosion
@onready var destroy_block: AudioStreamPlayer = $AudioBus/DestroyBlock
@onready var transition: AudioStreamPlayer = $AudioBus/Transition
@onready var ammo: AudioStreamPlayer = $AudioBus/Ammo
@onready var spooky: AudioStreamPlayer = $AudioBus/Spooky
@onready var victory: AudioStreamPlayer = $AudioBus/Victory
@onready var game_over: AudioStreamPlayer = $AudioBus/GameOver
@onready var pause: AudioStreamPlayer = $AudioBus/Pause


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("PAUSE"):
		if get_tree().paused:
			get_tree().paused = false
		else: 
			get_tree().paused = true
			pause.play()
