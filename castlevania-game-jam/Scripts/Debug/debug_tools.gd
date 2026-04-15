@tool
extends Node2D
class_name DebugPlayer
@onready var player: Player = $".."

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	var center : Vector2 = position
	var peak : Vector2 = Vector2(center.x, position.y - 48)
	var major_radius : float = 40.0
	var minor_radius : float = -peak.y
	var start_angle : float = 0 
	var end_angle : float = -PI 

	if Engine.is_editor_hint():
		draw_line(position, peak, Color.BLUE)
		draw_line(Vector2(position.x - major_radius, position.y), Vector2(position.x + major_radius, position.y), Color.RED)
		draw_ellipse_arc(center, major_radius, minor_radius, start_angle, end_angle, 40, Color.GREEN)
