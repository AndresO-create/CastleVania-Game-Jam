extends Area2D
class_name EdgeDetection
@onready var parent : Enemy = $".."



func _on_body_exited(body: Node2D) -> void:
	parent.detect_edge()
