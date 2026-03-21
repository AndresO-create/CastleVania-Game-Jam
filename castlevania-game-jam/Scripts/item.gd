extends RigidBody2D


func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()
