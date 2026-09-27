extends CanvasLayer
@onready var panel = $Panel
@onready var tick = $tick
var start = Vector2(584.0, 0)
var end = Vector2(1162.0, 0)
var open = false

func _ready() -> void:
	panel.position = end
	music.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music"))))
	sfx.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx"))))
	window.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	txt.set_pressed_no_signal(Global.skip)

func _on_start_pressed() -> void:
	Fade.change_scene("res://start/start.tscn")
	tick.play()
	
func _on_settings_pressed() -> void:
	tick.play()
	var tween = create_tween() ; var loc
	if open: loc = end ; open= false
	else: loc = start ; open = true
	tween.tween_property(panel, "position", loc, 0.5)



@onready var sfx = $Panel/VBoxContainer/sfx
@onready var music = $Panel/VBoxContainer/music
@onready var window = $Panel/VBoxContainer/fullscreen
@onready var txt  = $Panel/VBoxContainer/txt

func set_bus(bus_name, value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))


func _on_music_value_changed(value: float) -> void:
	set_bus("music", value)

func _on_sfx_value_changed(value: float) -> void:
	set_bus("sfx", value)
	$tick.play()

func _on_txt_toggled(toggled_on: bool) -> void:
	Global.skip = toggled_on
	$tick.play()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	$tick.play()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
