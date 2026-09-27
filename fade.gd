extends CanvasLayer

@onready var rect = $ColorRect

func change_scene(path: String, time = 0.5):
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, time)   # fade to black
	await tween.finished
	get_tree().change_scene_to_file(path)
	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, time)   # fade back in
	await tween.finished
