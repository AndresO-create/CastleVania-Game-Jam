extends RigidBody2D
class_name Orb

const CREDITS = preload("uid://b4ryk45kev2kp")


func _on_hitbox_body_entered(body: Node2D) -> void:
	var credits_instance = CREDITS.instantiate()
	get_node("/root/Root").add_sibling(credits_instance)
	get_node("/root/Root").queue_free()


func _on_spawn_timer_timeout() -> void:
	gravity_scale = 1.0
