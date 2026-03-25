extends Area2D
class_name Candle

func destroy_candle() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	destroy_candle()
