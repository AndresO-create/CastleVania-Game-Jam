extends CharacterBody2D
class_name Weapon
@onready var sprite: Sprite2D = $Sprite

@export var damage : int = 1
@onready var dir : int = $"../Player/Sprite".scale.x

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.damage_enemy(damage)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
