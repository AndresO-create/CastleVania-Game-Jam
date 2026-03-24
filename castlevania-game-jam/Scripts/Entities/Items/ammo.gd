extends Item

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.ammo += 1
	queue_free()
