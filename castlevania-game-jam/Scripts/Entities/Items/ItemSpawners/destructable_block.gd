extends Candle
class_name DestructableBlock

func _on_area_entered(area: Area2D) -> void:
	destroy_candle()
	GameManager.destroy_block.play()
