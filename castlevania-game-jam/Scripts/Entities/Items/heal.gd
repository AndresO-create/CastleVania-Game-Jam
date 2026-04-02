extends Item
@export var heal_val : int = 5

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health += heal_val
		queue_free()
