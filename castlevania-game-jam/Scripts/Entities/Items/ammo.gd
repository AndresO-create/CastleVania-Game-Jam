extends Item

#sprite texture to be changed depending on value of ammo
const AMMO_LARGE_SPRITE = preload("uid://bakp2wrgvyia")
const AMMO_SMALL_SPRITE = preload("uid://dxv33cc6j6318")

#value calculation
const SMALL_VALUE : int = 1
const LARGE_VALUE : int = 5
var value : int

func _ready() -> void:
	var random_int : int = randi_range(0, 4)
	match random_int:
		0, 1, 2, 3:
			$Sprite.texture = AMMO_SMALL_SPRITE
			$Sprite.position.y = 4.0
			value = 1
		4:
			$Sprite.texture = AMMO_LARGE_SPRITE
			value = 5

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.ammo += value
	queue_free()
