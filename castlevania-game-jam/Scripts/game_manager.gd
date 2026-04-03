extends Node

@export var current_level : int = 0

var whip_state = WHIP_STATES.ZERO
enum WHIP_STATES {ZERO, ONE, TWO}

#AUDIOBUS
@onready var explosion: AudioStreamPlayer = $AudioBus/Explosion
@onready var destroy_block: AudioStreamPlayer = $AudioBus/DestroyBlock
@onready var transition: AudioStreamPlayer = $AudioBus/Transition
@onready var ammo: AudioStreamPlayer = $AudioBus/Ammo
