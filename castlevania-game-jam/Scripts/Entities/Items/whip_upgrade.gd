extends Item

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		match body.whip_state:
			body.WHIP_STATES.ZERO:
				body.whip_state = body.WHIP_STATES.ONE
			body.WHIP_STATES.ONE:
				body.whip_state = body.WHIP_STATES.TWO
			_:
				body.whip_state = body.WHIP_STATES.TWO

		queue_free()
