extends CanvasLayer
@onready var panel = $Panel
@onready var tick = $tick
var start = Vector2(584.0, 0)
var end = Vector2(1162.0, 0)
var open = false

func _ready() -> void:
	panel.position = end

func _on_start_pressed() -> void:
	Fade.change_scene("res://start/start.tscn")
	tick.play()
	
func _on_settings_pressed() -> void:
	tick.play()
	var tween = create_tween() ; var loc
	if open: loc = end ; open= false
	else: loc = start ; open = true
	tween.tween_property(panel, "position", loc, 0.5)
