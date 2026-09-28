extends CanvasLayer
@onready var panel = $Panel
@onready var label = $Panel/txt

@onready var p = $buttons/settings/Panel

var ison = false

func _on_settings_pressed() -> void:
	$"../sounds/tick".play()
	var tween = create_tween()
	if ison:
		tween.tween_property(p, "position", Vector2(-287, 86), 1)
		ison = false
	else:
		tween.tween_property(p, "position", Vector2(-3, 86), 1)
		ison = true
	await tween.finished


var startPanel = Vector2(-241, 174)
var endPanel = Vector2(57, 174)
func move(w):
	var tween = create_tween()
	if w == "in":
		tween.tween_property(panel, "position", endPanel, 1)
	else:
		tween.tween_property(panel, "position", startPanel, 1)
	await tween.finished

	
var paused = false

func _on_stop_pressed() -> void:
	get_tree().paused = not get_tree().paused
