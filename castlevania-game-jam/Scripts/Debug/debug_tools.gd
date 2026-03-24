@tool
extends Node2D
class_name DebugPlayer
@onready var player: Player = $".."

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	var center : Vector2 = position#Vector2(0, (position.y - 80.33) / 2.0)
	var major_radius : float = 40.0
	var minor_radius : float = 80.0
	var peak : Vector2 = Vector2(center.x, position.y - 88)
	var start_angle : float = 0 #(peak - position).angle()
	var end_angle : float = -PI #(position - peak).angle()

	if Engine.is_editor_hint():
		draw_line(position, Vector2(position.x, position.y - 80.33), Color.BLUE)
		draw_line(Vector2(position.x - 40, position.y), Vector2(position.x + 40, position.y), Color.RED)
		draw_ellipse_arc(center, major_radius, minor_radius, start_angle, end_angle, 40, Color.GREEN)
