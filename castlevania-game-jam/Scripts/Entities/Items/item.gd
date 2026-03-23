extends RigidBody2D
class_name Item

func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()
